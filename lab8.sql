--câu 1--
go
CREATE PROCEDURE lab8_c1
    @manv NVARCHAR(10),
	@tennv NVARCHAR(50),
    @gioitinh NVARCHAR(3),
    @diachi NVARCHAR(50),
    @email NVARCHAR(50),
    @phong NVARCHAR(50),
    @flag INT
AS
BEGIN
   
    IF (@gioitinh <> N'Nam' AND @gioitinh <> N'Nữ')
    BEGIN
        SELECT 1 AS 'MaLoi', 'Giới tính không hợp lệ' AS 'MoTaLoi'
        RETURN
    END
    
  
    IF (@flag = 0)
    BEGIN
        INSERT INTO nhanvien (manv,tennv, gioitinh, diachi, email, phong)
        VALUES (@manv,@tennv, @gioitinh, @diachi, @email, @phong)
        SELECT 0 AS 'MaLoi', 'Thêm mới nhân viên thành công' AS 'MoTaLoi'
    END
    -- Ngược lại, flag = 1 thì cập nhật thông tin nhân viên
    ELSE
    BEGIN
        UPDATE nhanvien
        SET tennv=@tennv,
			gioitinh = @gioitinh,
            diachi = @diachi,
            email = @email,
            phong = @phong
        WHERE manv = @manv
        SELECT 0 AS 'MaLoi', 'Cập nhật thông tin nhân viên thành công' AS 'MoTaLoi'
    END
END
go
go
EXEC lab8_cau1 @manv = 'NV001',@tennv=N'Nguyên', @gioitinh = N'Nam', @diachi = N'Hà Nội', @email = N'example@gmail.com', 
    @phong = N'Vật tư', @flag = 0

go

--câu 2--
go
CREATE PROCEDURE lab8_cau2
    @masp INT,
    @tenhang NVARCHAR(50),
    @tensp NVARCHAR(50),
    @soluong INT,
    @mausac NVARCHAR(20),
    @giaban FLOAT,
    @donvitinh NVARCHAR(10),
    @mota NVARCHAR(MAX),
    @flag INT
AS
BEGIN
    DECLARE @mahangsx INT

    -- Kiểm tra xem tenhang có tồn tại trong bảng hangsx hay không
    SELECT @mahangsx = mahangsx FROM hangsx WHERE tenhang = @tenhang
    IF @mahangsx IS NULL
    BEGIN
        -- Trả về mã lỗi 1 nếu tenhang không tồn tại trong bảng hangsx
        SELECT 1 AS [ErrorCode], 'Ten hang khong ton tai' AS [Message]
        RETURN
    END

    -- Kiểm tra số lượng sản phẩm
    IF @soluong < 0
    BEGIN
        -- Trả về mã lỗi 2 nếu soluong < 0
        SELECT 2 AS [ErrorCode], 'So luong khong hop le' AS [Message]
        RETURN
    END

    IF @flag = 0 -- Thêm mới sản phẩm
    BEGIN
        INSERT INTO sanpham(masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
        VALUES(@masp, @mahangsx, @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota)

        SELECT 0 AS [ErrorCode], 'Them san pham thanh cong' AS [Message]
    END
    ELSE -- Cập nhật thông tin sản phẩm
    BEGIN
        UPDATE sanpham
        SET mahangsx = @mahangsx,
            tensp = @tensp,
            soluong = @soluong,
            mausac = @mausac,
            giaban = @giaban,
            donvitinh = @donvitinh,
            mota = @mota
        WHERE masp = @masp

        SELECT 0 AS [ErrorCode], 'Cap nhat san pham thanh cong' AS [Message]
    END
END
go
--câu 3--
go
CREATE PROCEDURE lab8_cau3
    @manv NVARCHAR(10)
AS
BEGIN

    IF NOT EXISTS (SELECT * FROM nhanvien WHERE manv = @manv)
    BEGIN