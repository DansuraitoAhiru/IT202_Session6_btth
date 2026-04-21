CREATE database btth;
USE btth;

CREATE TABLE Users(
	user_id INT PRIMARY KEY,
    user_name VARCHAR(50)
);
CREATE TABLE Hotels (
	hotel_id INT PRIMARY KEY,
    rating TINYINT
);
CREATE TABLE Bookings(
	booking_id int primary key,
    status varchar(10),
    total_price double,
    user_id int,
    hotel_id int,
    foreign key (user_id) references Users(user_id),
    foreign key (hotel_id) references Hotels(hotel_id)
);

INSERT INTO Users (user_id, user_name) 
VALUES
	(1, 'An'),
	(2, 'Binh'),
	(3, 'Chi'),
	(4, 'Dung'),
	(5, 'An');

INSERT INTO Hotels (hotel_id, rating) 
VALUES
	(101, 3),
	(102, 4),
	(103, 5),
	(104, 4),
	(105, 3);

INSERT INTO Bookings (booking_id, status, total_price, user_id, hotel_id) 
VALUES
	(1001, 'COMPLETED', 25000000, 1, 101),
	(1002, 'CANCELLED', 30000000, 1, 102),
	(1003, 'COMPLETED', 45000000, 2, 103),
	(1004, 'PENDING',   15000000, 3, 101),
	(1005, 'COMPLETED', -50000000, 3, 104),
	(1006, 'COMPLETED', -51000000, 4, 105),
	(1007, 'COMPLETED', 75000000, 5, 103),
	(1008, 'Pending', 40000000, 2, 102),
	(1009, 'COMPLETED', 58000000, 4, 104),
	(1010, 'COMPLETED', 60000000, 5, 103),
     (1011, 'COMPLETED', 30000000, 1, 103),
    (1012, 'COMPLETED', 25000000, 1, 103),
    (1013, 'COMPLETED', 20000000, 2, 104),
    (1014, 'COMPLETED', 35000000, 2, 104), 
    (1015, 'COMPLETED', 5200000, 3, 104),
    (1016, 'CANCELLED', 80000000, 4, 105),
    (1017, 'COMPLETED', 10000000, 5, 101),
    (1018, 'COMPLETED', 45000000, 5, 101),
    (1019, 'completed', 60000000, 3, 105),
    (1020, 'COMPLETED', 51000000, 4, 105);  

-- Phân tích luồng:
-- yêu cầu là hiển thị những khách hàng có Tổng chi tiêu cho một Hạng khách sạn
-- tổng chi tiêu sẽ phụ thuộc vào khách hàng và hạng khách
-- cụ thể là  một khách có thể tiêu tiền ở nhiều hạng khác nhau (3 sao, 4 sao, 5 sao) 
-- và hệ thống cần phân biệt rõ khách này chi cho hạng này bao nhiêu, hạng kia bao nhiêu, hạng này được khách này chi, khách kia chi như nào
-- nên phải phân biệt từng hạng, không được gộp chung
-- vì thế ta cần group 2 cộp user_id (phân biệt khách) và rating (phân biệt hạng)
-- ko dùng user_name mà buộc phải dùng user_id vì nếu mà có 2 khách trùng tên An thì cũng sẽ bị group thành 1
-- nhưng đề cũng yêu cầu phải lấy tên khách hàng nên chốt ta phải group cả 3 cột user_id, user_name và rating vì user_id sẽ giữ cho user_name trùng ko bị group thành 1

-- Chống bẫy:
-- ta nên xét điều kiện ở where vì where chạy trước khi nhóm và xử lý tính toán nên lọc từ đầu thì dữ liệu trong hàm giảm đi thì hàm làm việc nhanh hơn

SELECT u.user_name, h.rating,
sum(b.total_price) as total_amount
FROM Bookings b
JOIN Users u ON u.user_id = b.user_id
JOIN Hotels h ON h.hotel_id = b.hotel_id
WHERE b.status = 'COMPLETED' AND b.total_price > 0
GROUP BY u.user_id, u.user_name, h.rating
HAVING total_amount > 50000000; 