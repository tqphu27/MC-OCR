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
    
    <img src="https://user-images.githubusercontent.com/90370260/158927771-09873e0b-1f72-4d47-9805-528c24fe8e77.png">
  
  Thay vì nhân tất cả như CNN thì mô hình được tách ra.
  Đầu tiên, vaanxx thực hiện như standard CNN, thực hiện nhân tích chập 5x5x10 với bộ filter giờ chỉ còn là 1x3x3, tương tự 5 filter như thế, stack nó lại, kết quả thu được output 5x10x10.
  
  **Pointwise Convolution**: Ở bước pointwise này, ta chỉ sử dụng bộ có kích thước là 1x1. Đồng thời số lượng bộ lọc bằng số channel mà ta muốn thu được. Ta muốn tăng lên 64 channel, vậy hãy sử dụng 64 bộ filters.
  
  <img src="https://user-images.githubusercontent.com/90370260/158928256-42ca3daf-84ca-4fae-bdaa-3afdb986a43f.png">

2. Rotation corector
3. Textline rotation
4. Text classifier
5. Key information extraction
 Có rất nhiều mô hình với các hướng tiếp cận khác nhau trong bài toán trích xuất thông tin. Hướng tiếp cận đơn giản nhất là sử dụng Text Classification để phân loại ra những thông tin nào thuộc lớp nào.
 <img src="https://images.viblo.asia/full/b8fdd6ac-ddfa-4160-b573-b323836c190d.png">
 + Phương pháp a: Sử dụng đầu vào là text và box chứa text => dùng các công thức, mẫu chuẩn để giải quyết bài toán.
 + Phương pháp b: Sử dụng đầu vào là text và dụng một mô hình Encoder gồm các layer BiLSTM và Decoder sử dụng CRF để dự đoán thực thể đó.
 + Phương pháp c: sử dụng đầu vào là text và box chứa text đó đi qua một mô hình Encoder gồm các layer BiLSTM sau đó đưa qua một mô hình Graph gọi là GCN cuối cùng đưa qua mạng Decoder bao gồm cả BiLSTM và CRF để dự đoán ra thực thể đó.
 + Phương pháp d: Nhận đầu vào là text, box chứa text và cả image nữa . Đầu tiên cho qua một mô hình Encoder gồm (CNN+ Transformer) sau đó cho qua mô hình Graph gọi là GLCN rồi cuối cùng đưa vào mô hình Decoder bao gồm (BiLSTM+CRF) để đưa ra dự đoán cho thực thể đó. => PICK
 
  Sử dụng phương pháp d để giải quyết bài toán => Processing Key Information Extraction from Documents using Improved Graph Learning-Convolutional Networks.
  
  Pick sử dụng 3 modul chính:
   + Encoder: Sử dụng mô hình Transformer để trích xuất đặc trưng từ văn bản và sử dụng một mạng CNN để trích xuất đặc trưng từ ảnh. => Kết hợp với text embbedings và image embbedings lại thành vector biểu diễn X thể hiện khả năng biểu diễn text và image chứa text đó. => X được xem là đầu vào của Graph mô-đun.
   + Graph mô-đun: sử dụng một mạng GCN để làm giàu khả năng biểu diễn giữa các node. Việc các thông tin cần trích xuaatss có vị trí và nội dung khác nhau nó không cục bộ và không theo thứ tự nên việc sử dụng Graph giúp mô hình có thể học được khả năng biểu diễn mỗi tương quan giữa chúng về khoảng cách và vị trí trong văn bản.
   + Decoder: Sau khi kết hợp mô đun Graph để làm giàu thông tin thì mô hình kết hợp thông tin đó và cả thông tin do mô đun Encoder sunh ra để đưa vào mô đun Decoder để nhận dạng vầ phân loại chúng. Pick sử dụng BiLSTM layer và CRF layer.

  <src img="https://images.viblo.asia/full/4cbfec74-7277-4ce0-8473-47ef0c343dc9.png">
   + 
