from flask import Flask, render_template, request, redirect, url_for, flash
import mysql.connector

app = Flask(__name__)
app.secret_key = 'future_land_secret_key'

# Database configuration
def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",              
        password="",              
        database="dates_trading_db",
        port=3306
    )

# ---------------------------------------------------------
# 1. Dashboard Route (Analytics & Statistics)
# ---------------------------------------------------------
@app.route('/')
def index():
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute("SELECT SUM(Amount) as total FROM tbl_Transactions")
        total_spent = cur.fetchone()['total'] or 0

        cur.execute("SELECT COUNT(*) as total FROM tbl_Suppliers")
        total_suppliers = cur.fetchone()['total'] or 0

        cur.execute("SELECT COUNT(*) as total FROM tbl_Assets")
        total_assets = cur.fetchone()['total'] or 0

        cur.execute("SELECT SUM(Ad_spend) as total FROM tbl_Marketing")
        marketing_budget = cur.fetchone()['total'] or 0

        cur.execute("""
            SELECT t.Trans_ID, s.Name AS Supplier_Name, sh.Shipment_Date, c.Category_Name, t.Amount
            FROM tbl_Transactions AS t
            INNER JOIN tbl_Shipments AS sh ON t.Shipment_ID = sh.Shipment_ID
            INNER JOIN tbl_Suppliers AS s ON sh.Supplier_ID = s.Supplier_ID
            INNER JOIN tbl_Categories AS c ON t.Cat_ID = c.Cat_ID
            ORDER BY sh.Shipment_Date DESC LIMIT 5
        """)
        recent_transactions = cur.fetchall()
    except Exception as e:
        print(f"Database Error: {e}")
        total_spent = total_suppliers = total_assets = marketing_budget = 0
        recent_transactions = []
    finally:
        cur.close()
        conn.close()
        
    return render_template('dashboard.html', total=total_spent, total_suppliers=total_suppliers, 
                           total_assets=total_assets, marketing_budget=marketing_budget, 
                           transactions=recent_transactions)


# ---------------------------------------------------------
# 2. Suppliers Route (Manage tbl_Suppliers)
# ---------------------------------------------------------
@app.route('/suppliers', methods=['GET', 'POST'])
def suppliers():
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    
    if request.method == 'POST':
        name = request.form['name']
        cur.execute("INSERT INTO tbl_Suppliers (Name) VALUES (%s)", (name,))
        conn.commit()
        flash("Supplier Added Successfully!")
        return redirect(url_for('suppliers'))
        
    search = request.args.get('search', '')
    query = "SELECT * FROM tbl_Suppliers WHERE 1=1"
    params = []
    if search:
        query += " AND Name LIKE %s"
        params.append(f"%{search}%")
        
    cur.execute(query, tuple(params))
    all_suppliers = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('suppliers.html', suppliers=all_suppliers, search=search)


# ---------------------------------------------------------
# 3. Shipments Route (Manage tbl_Shipments)
# ---------------------------------------------------------
@app.route('/shipments', methods=['GET', 'POST'])
def shipments():
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    
    if request.method == 'POST':
        supplier_id = request.form['supplier_id']
        shipment_date = request.form['shipment_date']
        cur.execute("INSERT INTO tbl_Shipments (Supplier_ID, Shipment_Date) VALUES (%s, %s)", (supplier_id, shipment_date))
        conn.commit()
        flash("Shipment Added Successfully!")
        return redirect(url_for('shipments'))
        
    cur.execute("SELECT * FROM tbl_Suppliers")
    all_suppliers = cur.fetchall()
    
    cur.execute("""
        SELECT sh.Shipment_ID, s.Name as Supplier_Name, sh.Shipment_Date 
        FROM tbl_Shipments sh 
        INNER JOIN tbl_Suppliers s ON sh.Supplier_ID = s.Supplier_ID
        ORDER BY sh.Shipment_Date DESC
    """)
    all_shipments = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('shipments.html', shipments=all_shipments, suppliers=all_suppliers)


# ---------------------------------------------------------
# 4. Transactions Route (Fixed Foreign Key for Currency)
# ---------------------------------------------------------
@app.route('/transactions', methods=['GET', 'POST'])
def transactions_page():
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    
    if request.method == 'POST':
        shipment_id = request.form['shipment_id']
        cat_id = request.form['cat_id']
        amount = request.form['amount']
        pay_method = request.form['payment_method']
        currency_code = request.form['currency_code']
        
        try:
            cur.execute("""
                INSERT INTO tbl_Transactions (Shipment_ID, Cat_ID, Amount, Payment_Method, Currency_Code) 
                VALUES (%s, %s, %s, %s, %s)
            """, (shipment_id, cat_id, amount, pay_method, currency_code))
            conn.commit()
            flash("Transaction Added Successfully!")
        except mysql.connector.Error as err:
            flash(f"Database Error: {err.msg}")
            
        return redirect(url_for('transactions_page'))
        
    cur.execute("SELECT Shipment_ID FROM tbl_Shipments")
    all_shipments = cur.fetchall()
    cur.execute("SELECT * FROM tbl_Categories")
    all_categories = cur.fetchall()
    cur.execute("SELECT Currency_Code FROM tbl_exchange_rates")
    all_currencies = cur.fetchall()
    
    min_amount = request.args.get('amount', '')
    sort_by = request.args.get('sort', 'newest')
    
    query = """
        SELECT t.Trans_ID, s.Name AS Supplier_Name, sh.Shipment_Date, c.Category_Name, t.Amount, t.Payment_Method, t.Currency_Code
        FROM tbl_Transactions AS t
        INNER JOIN tbl_Shipments AS sh ON t.Shipment_ID = sh.Shipment_ID
        INNER JOIN tbl_Suppliers AS s ON sh.Supplier_ID = s.Supplier_ID
        INNER JOIN tbl_Categories AS c ON t.Cat_ID = c.Cat_ID
        WHERE 1=1
    """
    params = []
    if min_amount:
        query += " AND t.Amount > %s"
        params.append(int(min_amount))
        
    if sort_by == 'oldest':
        query += " ORDER BY sh.Shipment_Date ASC"
    else:
        query += " ORDER BY sh.Shipment_Date DESC"
        
    cur.execute(query, tuple(params))
    all_transactions = cur.fetchall()
    
    cur.close()
    conn.close()
    return render_template('transactions.html', transactions=all_transactions, shipments=all_shipments, 
                           categories=all_categories, currencies=all_currencies, min_amount=min_amount, sort_by=sort_by)


# ---------------------------------------------------------
# 5. Financial Report Route (Advanced GROUP BY & Aggregation)
# ---------------------------------------------------------
@app.route('/report')
def report():
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute("SELECT MAX(Amount) AS highest, MIN(Amount) AS lowest, AVG(Amount) AS average FROM tbl_Transactions")
        stats = cur.fetchone()
        highest = stats['highest'] or 0
        lowest = stats['lowest'] or 0
        average = stats['average'] or 0

        cur.execute("""
            SELECT c.Category_Name, SUM(t.Amount) AS Category_Total, COUNT(t.Trans_ID) AS Trans_Count
            FROM tbl_Transactions AS t
            INNER JOIN tbl_Categories AS c ON t.Cat_ID = c.Cat_ID
            GROUP BY c.Category_Name
        """)
        category_data = cur.fetchall()

        cur.execute("""
            SELECT s.Name AS Supplier_Name, s.Type AS Supplier_Type, 
                   SUM(t.Amount) AS Total_Deals, COUNT(t.Trans_ID) AS Total_Shipments
            FROM tbl_Suppliers AS s
            INNER JOIN tbl_Shipments AS sh ON s.Supplier_ID = sh.Supplier_ID
            INNER JOIN tbl_Transactions AS t ON sh.Shipment_ID = t.Shipment_ID
            GROUP BY s.Name, s.Type
            ORDER BY Total_Deals DESC
        """)
        supplier_report = cur.fetchall()
        
    except Exception as e:
        print(f"Report Error: {e}")
        highest = lowest = average = 0
        category_data = []
        supplier_report = []
    finally:
        cur.close()
        conn.close()
        
    return render_template('report.html', highest=highest, lowest=lowest, average=average, 
                           category_data=category_data, supplier_report=supplier_report)


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)