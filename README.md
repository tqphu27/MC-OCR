# MC-OCR 
- Project làm trên lượng dữ liệu từ cuộc thi MC-OCR [Link](https://aihub.vn/competitions/1.)
- Các bước làm tham khảo [Link](https://github.com/ndcuong91/MC_OCR?fbclid=IwAR1Qqyo0WDWCvENHZQ82kbQLXHbRBz0mjzBWmOjRk3m0hMU_QsnKNqgk2lc)

# Preprocessing
- Lượng dữ liệu có tổng cộng 1155 ảnh. Tuy nhiên có rất nhiều ảnh chưa đạt yêu cầu như gắn nhãn sai, nhầm thông tin, .. nên cần được lọc. => Sau khi lọc sẽ chỉ còn 1090 ảnh.
- Lọc danh sách tên các cửa hàng và địa chỉ.

# Training 
- Quá trình training gồm 5 bước chính
1. Text detector
- Sử dụng pre-trained từ [PaddleOCR](https://github.com/PaddlePaddle/PaddleOCR) 

+ MobileNets: Làm thế nào để MobileNets có thể rút gọn lại vài triệu tham số nhưng vẫn giữ được độ chính xác ổn, đó là nhờ sử dụng một cơ chế gọi là Depthwise Separable Convolutions.
  **Depthwise Separable Convolutions
    Mô hình chia CNN cơ bản ra làm hai phần: Deepwise Convolution và Pointwise Convolution.
    
    [](https://user-images.githubusercontent.com/90370260/158927771-09873e0b-1f72-4d47-9805-528c24fe8e77.png)
  
  Thay vì nhân tất cả như CNN thì mô hình được tách ra.
  Đầu tiên, vaanxx thực hiện như standard CNN, thực hiện nhân tích chập 5x5x10 với bộ filter giờ chỉ còn là 1x3x3, tương tự 5 filter như thế, stack nó lại, kết quả thu được output 5x10x10.
  
  **Pointwise Convolution**: Ở bước pointwise này, ta chỉ sử dụng bộ có kích thước là 1x1. Đồng thời số lượng bộ lọc bằng số channel mà ta muốn thu được. Ta muốn tăng lên 64 channel, vậy hãy sử dụng 64 bộ filters.
  
  [](https://user-images.githubusercontent.com/90370260/158928256-42ca3daf-84ca-4fae-bdaa-3afdb986a43f.png)

2. Rotation corector
3. Textline rotation
4. Text classifier
5. Key information extraction
