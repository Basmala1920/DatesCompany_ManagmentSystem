-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 16, 2026 at 06:11 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dates_trading_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_assets`
--

CREATE TABLE `tbl_assets` (
  `Asset_ID` int(11) NOT NULL,
  `Location_ID` int(11) NOT NULL,
  `Depreciation_Schedule` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_assets`
--

INSERT INTO `tbl_assets` (`Asset_ID`, `Location_ID`, `Depreciation_Schedule`) VALUES
(1, 2, 'الاستهلاك: 10% سنوياً - عمر افتراضي 10 سنوات'),
(2, 1, 'الاستهلاك: 20% سنوياً - عمر افتراضي 5 سنوات'),
(3, 3, 'الاستهلاك: 33% سنوياً - عمر افتراضي 3 سنوات'),
(4, 1, 'Office Equipment - 20% Annual'),
(5, 5, 'Heavy Duty Forklift - 15%'),
(6, 2, 'Refrigeration Unit 04 - 10%'),
(7, 4, 'POS System - 20%'),
(8, 6, 'Delivery Van 02 - 25%'),
(9, 8, 'Industrial Scales - 10%'),
(10, 3, 'Office Furniture Set - 15%'),
(11, 7, 'Backup Generator - 10%'),
(12, 1, 'Office Equipment - 20% Annual');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_categories`
--

CREATE TABLE `tbl_categories` (
  `Cat_ID` int(11) NOT NULL,
  `Category_Name` varchar(100) DEFAULT NULL CHECK (`Category_Name` in ('Business Expenses','Owner Drawings','Income'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_categories`
--

INSERT INTO `tbl_categories` (`Cat_ID`, `Category_Name`) VALUES
(1, 'Business Expenses'),
(2, 'Owner Drawings'),
(3, 'Income');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_exchange_rates`
--

CREATE TABLE `tbl_exchange_rates` (
  `Rate_ID` int(11) NOT NULL,
  `Currency_Code` varchar(3) NOT NULL,
  `Exchange_Rate` decimal(10,4) NOT NULL,
  `Effective_Date` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_exchange_rates`
--

INSERT INTO `tbl_exchange_rates` (`Rate_ID`, `Currency_Code`, `Exchange_Rate`, `Effective_Date`) VALUES
(1, 'AED', 1.0000, '2025-01-01'),
(2, 'USD', 3.6725, '2025-01-01'),
(3, 'UZS', 0.0003, '2025-01-01'),
(4, 'SAR', 0.9800, '2026-05-15'),
(5, 'EGP', 0.0750, '2026-05-15'),
(6, 'EUR', 4.0500, '2026-05-15'),
(7, 'GBP', 4.8000, '2026-05-15'),
(8, 'INR', 0.0440, '2026-05-15'),
(9, 'OMR', 9.5000, '2026-05-15'),
(10, 'KWD', 11.9000, '2026-05-15');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_locations`
--

CREATE TABLE `tbl_locations` (
  `Location_ID` int(11) NOT NULL,
  `Location_Name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_locations`
--

INSERT INTO `tbl_locations` (`Location_ID`, `Location_Name`) VALUES
(1, 'المخزن الرئيسي - دبي'),
(2, 'مخزن التبريد - الشارقة'),
(3, 'مكتب الإدارة'),
(4, 'منفذ بيع العوير'),
(5, 'مخزن جبل علي'),
(6, 'فرع أبو ظبي'),
(7, 'مخزن العين'),
(8, 'مستودع التبريد 3'),
(9, 'مكتب المتابعة'),
(10, 'جناح المعارض'),
(11, 'منفذ بيع العوير');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_marketing`
--

CREATE TABLE `tbl_marketing` (
  `Camp_ID` int(11) NOT NULL,
  `Campaign_Name` varchar(100) NOT NULL,
  `Ad_Spend` decimal(10,2) NOT NULL CHECK (`Ad_Spend` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_marketing`
--

INSERT INTO `tbl_marketing` (`Camp_ID`, `Campaign_Name`, `Ad_Spend`) VALUES
(1, 'جاسبر تسويق إلكتروني', 303.64),
(2, 'صناع الميديا فبراير', 600.00),
(3, 'حملات ممولة فيسبوك', 540.75),
(4, 'Instagram Ads', 400.00),
(5, 'TikTok Marketing', 900.00),
(6, 'Ramadan Early Bird', 2500.00),
(7, 'Google Search Ads', 800.00),
(8, 'Snapchat Filters', 350.00),
(9, 'Email Newsletter', 150.00),
(10, 'Influencer Gifting', 1100.00),
(11, 'B2B LinkedIn Ads', 600.00),
(12, 'Outdoor Banner', 2000.00);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_shipments`
--

CREATE TABLE `tbl_shipments` (
  `Shipment_ID` int(11) NOT NULL,
  `Supplier_ID` int(11) NOT NULL,
  `Shipment_Date` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_shipments`
--

INSERT INTO `tbl_shipments` (`Shipment_ID`, `Supplier_ID`, `Shipment_Date`) VALUES
(101, 1, '2025-11-01'),
(102, 2, '2025-11-15'),
(103, 3, '2025-12-01'),
(104, 4, '2025-12-15'),
(105, 6, '2026-01-15'),
(106, 7, '2026-01-20'),
(107, 8, '2026-02-01'),
(108, 10, '2026-02-10'),
(109, 12, '2026-02-15'),
(110, 11, '2026-03-01'),
(111, 6, '2026-03-05'),
(112, 12, '2026-05-06'),
(113, 1, '2026-05-16');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_suppliers`
--

CREATE TABLE `tbl_suppliers` (
  `Supplier_ID` int(11) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Type` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_suppliers`
--

INSERT INTO `tbl_suppliers` (`Supplier_ID`, `Name`, `Type`) VALUES
(1, 'أبو عبد الله', 'Partner/Supplier'),
(2, 'النخلة الجميلة', 'Main Supplier'),
(3, 'شركة هاندا', 'Supplier'),
(4, 'مزارع الوادي', 'Supplier'),
(5, 'شركة شحن دبي', 'Logistics'),
(6, 'مزارع القصيم', 'Supplier'),
(7, 'شركة النقل السريع', 'Logistics'),
(8, 'مصنع الكرتون الحديث', 'Packaging'),
(9, 'مؤسسة الريادة', 'Services'),
(10, 'مورد تمور المدينة', 'Supplier'),
(11, 'وكالة الشحن الدولية', 'Logistics'),
(12, 'شركة النجم الفضي', 'Supplier');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_transactions`
--

CREATE TABLE `tbl_transactions` (
  `Trans_ID` int(11) NOT NULL,
  `Shipment_ID` int(11) NOT NULL,
  `Cat_ID` int(11) NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `Payment_Method` varchar(50) NOT NULL,
  `Currency_Code` varchar(3) NOT NULL,
  `Amount` decimal(10,2) NOT NULL CHECK (`Amount` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_transactions`
--

INSERT INTO `tbl_transactions` (`Trans_ID`, `Shipment_ID`, `Cat_ID`, `Timestamp`, `Payment_Method`, `Currency_Code`, `Amount`) VALUES
(1, 101, 3, '2026-05-15 17:06:57', 'Bank Transfer', 'AED', 12000.00),
(2, 101, 1, '2026-05-15 17:06:57', 'Cash', 'AED', 77.70),
(3, 101, 1, '2026-05-15 17:06:57', 'Online', 'AED', 50.00),
(4, 101, 1, '2026-05-15 17:06:57', 'Cash', 'AED', 93.22),
(5, 102, 1, '2026-05-15 17:18:59', 'Cash', 'AED', 150.00),
(6, 103, 1, '2026-05-15 17:18:59', 'Online', 'AED', 300.00),
(7, 104, 3, '2026-05-15 17:18:59', 'Bank Transfer', 'AED', 5000.00),
(8, 102, 1, '2026-05-15 17:18:59', 'Cash', 'AED', 45.00),
(9, 103, 1, '2026-05-15 17:18:59', 'Cash', 'AED', 120.00),
(10, 104, 1, '2026-05-15 17:18:59', 'Online', 'AED', 80.00),
(11, 101, 2, '2026-05-15 17:18:59', 'Cash', 'AED', 500.00),
(12, 102, 3, '2026-05-15 17:18:59', 'Bank Transfer', 'AED', 2100.00),
(24, 101, 1, '2026-05-16 02:32:41', 'Cash', 'EGP', 5000.00),
(25, 103, 3, '2026-05-16 02:35:45', 'Cash', 'AED', 1.00),
(26, 105, 3, '2026-05-16 02:42:47', 'Bank Transfer', 'AED', 25000.00),
(27, 106, 1, '2026-05-16 02:42:47', 'Cash', 'AED', 450.00),
(28, 107, 1, '2026-05-16 02:42:47', 'Cheque', 'AED', 3200.00),
(29, 108, 3, '2026-05-16 02:42:47', 'Bank Transfer', 'AED', 15700.00),
(30, 109, 1, '2026-05-16 02:42:47', 'Online', 'AED', 890.00),
(31, 110, 1, '2026-05-16 02:42:47', 'Cash', 'AED', 2100.00),
(32, 111, 2, '2026-05-16 02:42:47', 'Cash', 'AED', 3000.00);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_assets`
--
ALTER TABLE `tbl_assets`
  ADD PRIMARY KEY (`Asset_ID`),
  ADD KEY `Location_ID` (`Location_ID`);

--
-- Indexes for table `tbl_categories`
--
ALTER TABLE `tbl_categories`
  ADD PRIMARY KEY (`Cat_ID`);

--
-- Indexes for table `tbl_exchange_rates`
--
ALTER TABLE `tbl_exchange_rates`
  ADD PRIMARY KEY (`Rate_ID`),
  ADD UNIQUE KEY `Currency_Code` (`Currency_Code`);

--
-- Indexes for table `tbl_locations`
--
ALTER TABLE `tbl_locations`
  ADD PRIMARY KEY (`Location_ID`);

--
-- Indexes for table `tbl_marketing`
--
ALTER TABLE `tbl_marketing`
  ADD PRIMARY KEY (`Camp_ID`);

--
-- Indexes for table `tbl_shipments`
--
ALTER TABLE `tbl_shipments`
  ADD PRIMARY KEY (`Shipment_ID`),
  ADD KEY `Supplier_ID` (`Supplier_ID`);

--
-- Indexes for table `tbl_suppliers`
--
ALTER TABLE `tbl_suppliers`
  ADD PRIMARY KEY (`Supplier_ID`),
  ADD UNIQUE KEY `Name` (`Name`);

--
-- Indexes for table `tbl_transactions`
--
ALTER TABLE `tbl_transactions`
  ADD PRIMARY KEY (`Trans_ID`),
  ADD KEY `Shipment_ID` (`Shipment_ID`),
  ADD KEY `Cat_ID` (`Cat_ID`),
  ADD KEY `Currency_Code` (`Currency_Code`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_assets`
--
ALTER TABLE `tbl_assets`
  MODIFY `Asset_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `tbl_categories`
--
ALTER TABLE `tbl_categories`
  MODIFY `Cat_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_exchange_rates`
--
ALTER TABLE `tbl_exchange_rates`
  MODIFY `Rate_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `tbl_locations`
--
ALTER TABLE `tbl_locations`
  MODIFY `Location_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `tbl_marketing`
--
ALTER TABLE `tbl_marketing`
  MODIFY `Camp_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `tbl_shipments`
--
ALTER TABLE `tbl_shipments`
  MODIFY `Shipment_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- AUTO_INCREMENT for table `tbl_suppliers`
--
ALTER TABLE `tbl_suppliers`
  MODIFY `Supplier_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `tbl_transactions`
--
ALTER TABLE `tbl_transactions`
  MODIFY `Trans_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_assets`
--
ALTER TABLE `tbl_assets`
  ADD CONSTRAINT `tbl_assets_ibfk_1` FOREIGN KEY (`Location_ID`) REFERENCES `tbl_locations` (`Location_ID`);

--
-- Constraints for table `tbl_shipments`
--
ALTER TABLE `tbl_shipments`
  ADD CONSTRAINT `tbl_shipments_ibfk_1` FOREIGN KEY (`Supplier_ID`) REFERENCES `tbl_suppliers` (`Supplier_ID`);

--
-- Constraints for table `tbl_transactions`
--
ALTER TABLE `tbl_transactions`
  ADD CONSTRAINT `tbl_transactions_ibfk_1` FOREIGN KEY (`Shipment_ID`) REFERENCES `tbl_shipments` (`Shipment_ID`),
  ADD CONSTRAINT `tbl_transactions_ibfk_2` FOREIGN KEY (`Cat_ID`) REFERENCES `tbl_categories` (`Cat_ID`),
  ADD CONSTRAINT `tbl_transactions_ibfk_3` FOREIGN KEY (`Currency_Code`) REFERENCES `tbl_exchange_rates` (`Currency_Code`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
