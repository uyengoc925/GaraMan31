
DROP DATABASE IF EXISTS garaman_db;
CREATE DATABASE garaman_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE garaman_db;

-- =====================================================================
-- PHẦN 1: DDL
-- =====================================================================

-- ---------- Nhóm người dùng (kế thừa Person2) ----------
CREATE TABLE tblPerson2 (
id          INT AUTO_INCREMENT PRIMARY KEY,
fullName    VARCHAR(255) NOT NULL,
gender      CHAR(5)      NULL,
phoneNumber VARCHAR(20)  NOT NULL UNIQUE,
email       VARCHAR(100) NULL,
address     VARCHAR(255) NULL
);

CREATE TABLE tblCustomer2 (
tblPerson2id INT PRIMARY KEY,
FOREIGN KEY (tblPerson2id) REFERENCES tblPerson2(id)
);

CREATE TABLE tblEmployee2 (
tblPerson2id INT PRIMARY KEY,
username     VARCHAR(255) NOT NULL UNIQUE,
`password`   VARCHAR(255) NOT NULL,
`position`   VARCHAR(255) NOT NULL,
FOREIGN KEY (tblPerson2id) REFERENCES tblPerson2(id)
);

CREATE TABLE tblSalesStaff2 (
tblPerson2id INT PRIMARY KEY,
FOREIGN KEY (tblPerson2id) REFERENCES tblEmployee2(tblPerson2id)
);

CREATE TABLE tblWarehouseStaff2 (
tblPerson2id INT PRIMARY KEY,
FOREIGN KEY (tblPerson2id) REFERENCES tblEmployee2(tblPerson2id)
);


-- ---------- Phương tiện & lịch hẹn ----------
CREATE TABLE tblVehicle2 (
id             INT AUTO_INCREMENT PRIMARY KEY,
licensePlate   VARCHAR(20)  NOT NULL UNIQUE ,
brand          VARCHAR(50)  NOT NULL,
vehicleType    VARCHAR(50)  NOT NULL,
color          VARCHAR(30)  NOT NULL,
description    VARCHAR(255) NULL,
tblCustomer2id INT NOT NULL,
FOREIGN KEY (tblCustomer2id) REFERENCES tblCustomer2(tblPerson2id)
);

CREATE TABLE tblAppointment2 (
id               INT AUTO_INCREMENT PRIMARY KEY,
`date`           DATE        NOT NULL,
`time`           TIME        NOT NULL,
status           VARCHAR(50) NOT NULL,
tblVehicle2id    INT NOT NULL,
tblSalesStaff2id INT NULL,
FOREIGN KEY (tblVehicle2id)    REFERENCES tblVehicle2(id),
FOREIGN KEY (tblSalesStaff2id) REFERENCES tblSalesStaff2(tblPerson2id)
);



-- ---------- Phụ tùng ----------
CREATE TABLE tblPartCategory2 (
id           INT AUTO_INCREMENT PRIMARY KEY,
categoryName VARCHAR(255) NOT NULL UNIQUE,
description  VARCHAR(255) NOT NULL,
status       VARCHAR(50)  NOT NULL
);

CREATE TABLE tblSparePart2 (
id                INT AUTO_INCREMENT PRIMARY KEY,
partName          VARCHAR(255)  NOT NULL UNIQUE,
unit              VARCHAR(50)   NOT NULL,
unitPrice         DECIMAL(18,2) NOT NULL,
minimumStock      INT           NOT NULL,
actualStock       INT           NOT NULL,
description       VARCHAR(255)  NOT NULL,
status            VARCHAR(50)   NOT NULL,
tblPartCategory2id INT NOT NULL,
FOREIGN KEY (tblPartCategory2id) REFERENCES tblPartCategory2(id)
);



-- ---------- Nhà cung cấp & nhập kho ----------
CREATE TABLE tblSupplier2 (
id            INT AUTO_INCREMENT PRIMARY KEY,
supplierName  VARCHAR(255) NOT NULL ,
phoneNumber   VARCHAR(20)  NOT NULL UNIQUE ,
contactPerson VARCHAR(255)  NOT NULL,
address       VARCHAR(255) NOT NULL ,
taxCode       VARCHAR(50) NOT NULL  UNIQUE ,
status        VARCHAR(50) NOT NULL
);

CREATE TABLE tblImportReceipt2 (
id                  INT AUTO_INCREMENT PRIMARY KEY,
importDateTime      date    NOT NULL,
status              VARCHAR(50) NOT NULL,
tblSupplier2id      INT NOT NULL,
tblWarehouseStaff2id INT NOT NULL,
FOREIGN KEY (tblSupplier2id)       REFERENCES tblSupplier2(id),
FOREIGN KEY (tblWarehouseStaff2id) REFERENCES tblWarehouseStaff2(tblPerson2id)
);

CREATE TABLE tblImportReceiptDetail2 (
id                  INT AUTO_INCREMENT PRIMARY KEY,
importQuantity      INT           NOT NULL,
importUnitPrice     DECIMAL(18,2) NOT NULL,
tblImportReceipt2id INT NOT NULL,
tblSparePart2id     INT NOT NULL,
FOREIGN KEY (tblImportReceipt2id) REFERENCES tblImportReceipt2(id),
FOREIGN KEY (tblSparePart2id)     REFERENCES tblSparePart2(id)
);

-- =====================================================================
-- PHẦN 2: Dữ liệu mẫu
-- =====================================================================
INSERT INTO tblPerson2 (fullName, gender, phoneNumber, email, address) VALUES
('Nguyễn Văn Khách', 'Nam', '0901111111', 'khach1@gmail.com', 'Hà Nội'),
('Trần Thị Hàng', 'Nữ', '0902222222', 'khach2@gmail.com', 'Hà Nội'),
('Lê Văn Mua', 'Nam', '0903333333', 'khach3@gmail.com', 'Hà Nội'),
('Phạm Thị Tiền', 'Nữ', '0904444444', 'khach4@gmail.com', 'Hà Nội'),
('Hoàng Văn Xa', 'Nam', '0905555555', 'khach5@gmail.com', 'Hà Nội'),
('Nguyễn Sale Một', 'Nam', '0911111111', 'sale1@garaman.com', 'Hà Nội'),
('Trần Sale Hai', 'Nữ', '0912222222', 'sale2@garaman.com', 'Hà Nội'),
('Lê Kho Một', 'Nam', '0921111111', 'kho1@garaman.com', 'Hà Nội'),
('Phạm Kho Hai', 'Nữ', '0922222222', 'quanly@garaman.com', 'Hà Nội');

-- 2. Thêm dữ liệu vào bảng tblCustomer2 (Lấy Person ID từ 1 đến 5)
INSERT INTO tblCustomer2 (tblPerson2id) VALUES
(1), (2), (3), (4), (5);

-- 3. Thêm dữ liệu vào bảng tblEmployee2 (Lấy Person ID từ 6 đến 9)
-- Giả sử mật khẩu mặc định là '123456'
INSERT INTO tblEmployee2 (tblPerson2id, username, password, position) VALUES
(6, 'sale1', '123456', 'Sales'),
(7, 'sale2', '123456', 'Sales'),
(8, 'kho1', '123456', 'Warehouse'),
(9, 'quanly', '123456', 'Manager');

-- 4. Thêm dữ liệu vào bảng tblSalesStaff2 (Lấy từ Employee ID 6, 7)
INSERT INTO tblSalesStaff2 (tblPerson2id) VALUES
(6), (7);

-- 5. Thêm dữ liệu vào bảng tblWarehouseStaff2 (Lấy từ Employee ID 8, 9)
INSERT INTO tblWarehouseStaff2 (tblPerson2id) VALUES
(8), (9);

-- 6. Thêm dữ liệu vào bảng tblVehicle2 (Thuộc về các Customer từ 1 đến 5)
INSERT INTO tblVehicle2 (licensePlate, brand, vehicleType, color, description, tblCustomer2id) VALUES
('30A-123.45', 'Toyota', 'Vios', 'Trắng', 'Xe gia đình', 1),
('30F-678.90', 'Honda', 'CR-V', 'Đen', 'Xe hay đi tỉnh', 2),
('29C-333.33', 'Ford', 'Ranger', 'Cam', 'Xe bán tải chở hàng', 3),
('30G-555.55', 'Hyundai', 'Accent', 'Đỏ', 'Bảo dưỡng định kỳ', 4),
('29D-999.99', 'Mazda', 'CX-5', 'Xanh', 'Trầy xước nhẹ cửa', 5),
('30K-111.22', 'Toyota', 'Camry', 'Đen', 'Xe dự phòng', 1);

-- 7. Thêm dữ liệu vào bảng tblAppointment2
-- Có lịch đã xác nhận (có Sales phụ trách) và lịch đặt online mới (Sales NULL)
INSERT INTO tblAppointment2 (`date`, `time`, status, tblVehicle2id, tblSalesStaff2id) VALUES
('2026-11-15', '08:30:00', 'Đã xác nhận', 1, 6),
('2026-11-15', '09:00:00', 'Đã xác nhận', 2, 7),
('2026-11-16', '10:00:00', 'Chờ xác nhận', 3, NULL),
('2026-11-16', '14:30:00', 'Chờ xác nhận', 4, NULL),
('2026-11-17', '15:00:00', 'Đã xác nhận', 5, 6);

-- 8. Thêm dữ liệu vào bảng tblPartCategory2
INSERT INTO tblPartCategory2 (categoryName, description, status) VALUES
('Dầu nhớt & Chất lỏng', 'Các loại dầu máy, nước làm mát, dầu phanh', 'Hoạt động'),
('Lốp xe', 'Các loại lốp thay thế cho ô tô', 'Hoạt động'),
('Hệ thống Phanh', 'Má phanh, đĩa phanh', 'Hoạt động'),
('Phụ kiện nội thất', 'Thảm trải sàn, bọc vô lăng, nước hoa', 'Hoạt động');

-- 9. Thêm dữ liệu vào bảng tblSparePart2
INSERT INTO tblSparePart2 (partName, unit, unitPrice, minimumStock, actualStock, description, status, tblPartCategory2id) VALUES
('Dầu nhớt Castrol GTX', 'Chai 4L', 450000.00, 10, 50, 'Dầu động cơ cao cấp', 'Đang bán', 1),
('Nước làm mát Prestone', 'Can 1L', 120000.00, 20, 100, 'Nước mát pha sẵn màu đỏ', 'Đang bán', 1),
('Lốp Michelin 235/55R19', 'Quả', 3500000.00, 8, 30, 'Lốp dùng cho SUV/Crossover', 'Đang bán', 2),
('Lốp Bridgestone 185/60R15', 'Quả', 1500000.00, 10, 40, 'Lốp dùng cho sedan', 'Đang bán', 2),
('Má phanh trước Toyota Vios', 'Bộ', 800000.00, 5, 15, 'Má phanh chính hãng Toyota', 'Đang bán', 3),
('Thảm lót sàn 6D', 'Bộ', 1200000.00, 5, 20, 'Thảm lót sàn ô tô cao cấp', 'Đang bán', 4);

-- 10. Thêm dữ liệu vào bảng tblSupplier2
INSERT INTO tblSupplier2 (supplierName, phoneNumber, contactPerson, address, taxCode, status) VALUES
('Công ty Phụ tùng ô tô Bosch VN', '0243111222', 'Anh Tùng', 'KCN Thăng Long, Hà Nội', '0101234567', 'Đang hợp tác'),
('Đại lý Lốp xe Dân Chủ', '0243999888', 'Chị Hoa', 'Hà Đông, Hà Nội', '0109876543', 'Đang hợp tác'),
('Công ty TNHH Dầu nhớt Castrol', '0283777666', 'Anh Hùng', 'Quận 1, TP. HCM', '0301112223', 'Đang hợp tác');

-- 11. Thêm dữ liệu vào bảng tblImportReceipt2
-- Lưu ý: field importDateTime được thiết kế kiểu `date` trong schema
INSERT INTO tblImportReceipt2 (importDateTime, status, tblSupplier2id, tblWarehouseStaff2id) VALUES
('2026-10-01', 'Đã nhập kho', 1, 8),
('2026-10-15', 'Đã nhập kho', 2, 8),
('2026-11-01', 'Đang giao hàng', 3, 8);

-- 12. Thêm dữ liệu vào bảng tblImportReceiptDetail2
-- Receipt 1 (Từ Bosch) nhập Má phanh (ID 5)
INSERT INTO tblImportReceiptDetail2 (importQuantity, importUnitPrice, tblImportReceipt2id, tblSparePart2id) VALUES
(20, 700000.00, 1, 5);

-- Receipt 2 (Từ Dân Chủ) nhập Lốp (ID 3, 4)
INSERT INTO tblImportReceiptDetail2 (importQuantity, importUnitPrice, tblImportReceipt2id, tblSparePart2id) VALUES
(40, 3200000.00, 2, 3),
(50, 1350000.00, 2, 4);

-- Receipt 3 (Từ Castrol) nhập Dầu nhớt & Nước mát (ID 1, 2)
INSERT INTO tblImportReceiptDetail2 (importQuantity, importUnitPrice, tblImportReceipt2id, tblSparePart2id) VALUES
(100, 400000.00, 3, 1),
(200, 100000.00, 3, 2);
-- 13. Thêm phiếu nhập (id 4 -> 12), nối tiếp 3 phiếu có sẵn
INSERT INTO tblImportReceipt2 (id, importDateTime, status, tblSupplier2id, tblWarehouseStaff2id) VALUES
(4,  '2026-08-03', 'Hoàn thành', 1, 8),
(5,  '2026-08-07', 'Hoàn thành', 2, 9),
(6,  '2026-08-12', 'Hoàn thành', 3, 8),
(7,  '2026-08-18', 'Hoàn thành', 1, 9),
(8,  '2026-08-22', 'Hoàn thành', 2, 8),
(9,  '2026-08-28', 'Hoàn thành', 3, 9),
(10, '2026-08-30', 'Hoàn thành', 1, 8),
(11, '2026-09-05', 'Hoàn thành', 2, 8),   -- ngoài khoảng tháng 8, dùng để test lọc ngày
(12, '2026-08-15', 'Đã hủy',     3, 9);   -- khác trạng thái, dùng để test lọc status

-- 14. Thêm chi tiết phiếu nhập
INSERT INTO tblImportReceiptDetail2 (importQuantity, importUnitPrice, tblImportReceipt2id, tblSparePart2id) VALUES
-- Phiếu 4 (Bosch): má phanh
(30, 720000.00, 4, 5),
-- Phiếu 5 (Dân Chủ): lốp
(20, 3250000.00, 5, 3),
(25, 1400000.00, 5, 4),
-- Phiếu 6 (Castrol): dầu nhớt, nước làm mát
(60, 410000.00, 6, 1),
(80, 105000.00, 6, 2),
-- Phiếu 7 (Bosch): má phanh, thảm lót sàn
(15, 710000.00, 7, 5),
(10, 1100000.00, 7, 6),
-- Phiếu 8 (Dân Chủ): lốp
(35, 3300000.00, 8, 3),
-- Phiếu 9 (Castrol): dầu nhớt
(120, 405000.00, 9, 1),
-- Phiếu 10 (Bosch): thảm lót sàn
(12, 1150000.00, 10, 6),
-- Phiếu 11 (Dân Chủ, tháng 9): lốp
(40, 1380000.00, 11, 4),
-- Phiếu 12 (Castrol, Đã hủy): nước làm mát
(50, 100000.00, 12, 2);