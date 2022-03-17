# MC-OCR 
- Project làm trên lượng dữ liệu từ cuộc thi MC-OCR ![Link](https://aihub.vn/competitions/1.)
- Các bước làm tham khảo ![Link[(https://github.com/ndcuong91/MC_OCR?fbclid=IwAR1Qqyo0WDWCvENHZQ82kbQLXHbRBz0mjzBWmOjRk3m0hMU_QsnKNqgk2lc)

# Preprocessing
- Lượng dữ liệu có tổng cộng 1155 ảnh. Tuy nhiên có rất nhiều ảnh chưa đạt yêu cầu như gắn nhãn sai, nhầm thông tin, .. nên cần được lọc. => Sau khi lọc sẽ chỉ còn 1090 ảnh.
- Lọc danh sách tên các cửa hàng và địa chỉ.

# Training 
- Quá trình training gồm 5 bước chính
1. Text detector
- Sử dụng pre-trained từ ![PaddleOCR](https://github.com/PaddlePaddle/PaddleOCR) 
- 
2. Rotation corector
3. Textline rotation
4. Text classifier
5. Key information extraction
