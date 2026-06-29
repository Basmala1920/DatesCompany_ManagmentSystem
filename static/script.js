function filterTable() {
  let searchValue = document.getElementById("searchInput").value.toLowerCase();

  let amountValue = document.getElementById("amountInput").value;

  let table = document.getElementById("transactionsTable");

  let rows = table.getElementsByTagName("tr");

  for (let i = 1; i < rows.length; i++) {
    let supplier = rows[i].getElementsByTagName("td")[0];

    let amount = rows[i].getElementsByTagName("td")[3];

    if (supplier && amount) {
      let supplierText = supplier.textContent.toLowerCase();

      let amountNumber = parseInt(amount.textContent);

      let searchMatch = supplierText.includes(searchValue);
      let amountMatch =
        amountValue === "" || amountNumber > parseInt(amountValue);

      if (searchMatch && amountMatch) {
        rows[i].style.display = "";
      } else {
        rows[i].style.display = "none";
      }
    }
  }
}
function sortNewest() {
  let table = document.getElementById("transactionsTable");

  let rows = Array.from(table.rows).slice(1);

  rows.sort((a, b) => {
    let dateA = new Date(a.cells[1].innerHTML);

    let dateB = new Date(b.cells[1].innerHTML);

    return dateB - dateA;
  });

  rows.forEach((row) => table.appendChild(row));
}
function sortOldest() {
  let table = document.getElementById("transactionsTable");

  let rows = Array.from(table.rows).slice(1);

  rows.sort((a, b) => {
    let dateA = new Date(a.cells[1].innerHTML);

    let dateB = new Date(b.cells[1].innerHTML);

    return dateA - dateB;
  });
  rows.forEach((row) => table.appendChild(row));
}
function submitWithSort(sortType) {
  document.getElementById("sortInput").value = sortType;
  document.getElementById("searchInput").form.submit();
}
