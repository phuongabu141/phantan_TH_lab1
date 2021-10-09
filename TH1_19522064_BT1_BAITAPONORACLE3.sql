--------------------195222064_NGUYEN THI MAI PHUONG ----------
----------------------- DE 03---------------------

----TAO BANG (CAU1, CAU2)
CREATE TABLE BaiTapTH03.HANGHANGKHONG
(
    MAHANG VARCHAR2(2) CONSTRAINT PK_HANGHANGKHONG PRIMARY KEY,
    TENHANG VARCHAR2(20),
    NGTL DATE,
    DUONGBAY NUMBER
)

CREATE TABLE BaiTapTH03.CHUYENBAY
(
    MACB VARCHAR(5) CONSTRAINT PK_CHUYENBAY PRIMARY KEY,
    MAHANG VARCHAR2(2),
    XUATPHAT VARCHAR2(10),
    DIEMDEN VARCHAR2(15),
    BATDAU DATE,
    TGBAY NUMBER
)
--DROP TABLE BaiTapTH03.CHUYENBAY;

CREATE TABLE BaiTapTH03.NHANVIEN
(
    MANV VARCHAR(4) CONSTRAINT PK_NHANVIEN PRIMARY KEY,
    HOTEN VARCHAR2(20), 
    GIOITINH VARCHAR2(3),
    NGAYSINH DATE,
    NGAVL DATE,
    CHUYENMON VARCHAR2(15)
)

CREATE TABLE BaiTapTH03.PHANCONG
(
    MACB VARCHAR2(5),
    MANV VARCHAR2(4),
    NHIEMVU VARCHAR2(30),
    CONSTRAINT PK_PHANCONG PRIMARY KEY(MACB,MANV)
)
--DROP TABLE BaiTapTH03.PHANCONG;
--INSERT DATA
ALTER SESSION SET NLS_DATE_FORMAT =' DD/MM/YYYY HH24:MI:SS ';
INSERT INTO BaiTapTH03.HANGHANGKHONG VALUES ('VN', 'Vietnam Airlines','15/01/1956', '52');
INSERT INTO BaiTapTH03.HANGHANGKHONG VALUES ('VJ', 'Vietjet Air', '25/12/2011', '33');
INSERT INTO BaiTapTH03.HANGHANGKHONG VALUES ('BL', 'Jetstar Pacific', '01/12/1990', '13');

INSERT INTO BaiTapTH03.CHUYENBAY VALUES ( 'VN550', 'VN', 'TP.HCM', 'Singapore', '20/12/2015 ', '2');
INSERT INTO BaiTapTH03.CHUYENBAY VALUES ('VJ331', 'VJ', '?a Nang', 'Vinh', '28/12/2015', '1' );
INSERT INTO BaiTapTH03.CHUYENBAY VALUES ( 'BL696', 'BL', 'TP. HCM', '?a Lat', '24/12/2015', '0.5');

INSERT INTO BaiTapTH03.NHANVIEN VALUES ('NV01', 'Lam Van Ben', 'Nam','10/09/1978', '05/06/2000', 'Phi cong');
INSERT INTO BaiTapTH03.NHANVIEN VALUES ('NV02', 'Duong Thi Luc', 'Nu', '22/03/1989', '12/11/2013', 'Tiep vien');
INSERT INTO BaiTapTH03.NHANVIEN VALUES ('NV03', 'Hoang Thanh Tung', 'Nam', '29/07/1983', '11/04/2007', 'Tiep vien');

INSERT INTO BaiTapTH03.PHANCONG VALUES ('VN550', 'NV01', 'Co truong');
INSERT INTO BaiTapTH03.PHANCONG VALUES ('VN550', 'NV02', 'Tiep vien');
INSERT INTO BaiTapTH03.PHANCONG VALUES ('BL696', 'NV03', 'Tiep vien truong');

-- KHOA NGOAI
ALTER TABLE BaiTapTH03.CHUYENBAY
ADD CONSTRAINT FK_CHUYENBAY FOREIGN KEY (MAHANG) REFERENCES BaiTapTH03.HANGHANGKHONG (MAHANG);
ALTER TABLE BaiTapTH03.PHANCONG
ADD CONSTRAINT FK_PHANCONG_1 FOREIGN KEY (MACB) REFERENCES BaiTapTH03.CHUYENBAY (MACB);
ALTER TABLE BaiTapTH03.PHANCONG
ADD CONSTRAINT FK_PHANCONG_2 FOREIGN KEY (MANV) REFERENCES BaiTapTH03.NHANVIEN;

-- CAU 3
ALTER TABLE BaiTapTH03.NHANVIEN
ADD CONSTRAINT NHANVIEN_CHECK CHECK (CHUYENMON = 'Phi Cong' or CHUYENMON = 'Tiep vien')
ENABLE NOVALIDATE;

--CAU 5:
SELECT *
FROM BaiTapTH03.NHANVIEN
WHERE EXTRACT (MONTH FROM(NGAYSINH)) =7;

--CAU 6
SELECT MACB
FROM BaiTapTH03.PHANCONG
GROUP BY MACB
HAVING COUNT(MANV)<= ALL
    (
        SELECT COUNT(MANV)
        FROM BaiTapTH03.PHANCONG
        GROUP BY MACB
    );
    
-- CAU 7:
SELECT CB.MACB
FROM BaiTapTH03.CHUYENBAY CB, BaiTapTH03.PHANCONG PC
WHERE CB.MACB=PC.MACB AND CB.XUATPHAT='Da Nang'
GROUP BY PC.MACB
HAVING COUNT (CB.MANV) =
    ( 
        SELECT COUNT(PC1.MANV)
        FROM BaiTapTH03.PHANCONG PC1
        WHERE PC1.MANV=CB.MANV AND PC1.MACB=CB.MACB
        GROUP BY PC1.MACB
        HAVING COUNT(PC1.MANV)<=2
    );

-- CAU 8:
SELECT *
FROM BaiTapTH03.NHANVIEN NV 
WHERE NOT EXISTS 
    (
        SELECT * 
        FROM BaiTapTH03.CHUYENBAY CB 
        WHERE NOT EXISTS 
            (
                SELECT *
                FROM BaiTapTH03.PHANCONG PC
                WHERE PC.MANV=NV.MANV AND  PC.MACB=CB.MACB
            )
    )