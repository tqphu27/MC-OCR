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
 
  **Encoder**
 - Gồm hai luồng xử lý. Luồng đầu tiên, sử dụng các vùng text để đưa mô hình Transformer giúp việc trích xuất dữ liệu từ dạng text.
 - Luồng thứ hai sử dụng một mạng CNN để trích xuất dữ liệu từ dạng text. Mặt khác, luồng thứ 2 sử dụng một mạng CNN để trích xuất đặc trưng từ các vùng ảnh. Sau đó kết hợp chúng lại bằng phép toán cộng ma trận được một ma trận X.
 => X được sử dụng làm input X0 của Graph Module bằng cách qua một layer pooling.
 
 **Graph mô-đun**
  Mô hình sử dụng một graph neural network để mô hình hóa bối cảnh toàn cục và các thông tin có cấu trúc không tuần tự để xác định trước loại cạnh và ma trận kề của đồ thị. cạnh là việc các nodes/text segments kết nối với nhau theo chiều ngang hay dọc. 
  Ma trận kề được xác định dựa trên 4 loại cạnh: "trái sang phải",....
  Pick sử dụng kết hợp phát triển mạng Graph learning-convolutional dựa trên mô hình Graph để học một soft adjacent matrix thay vì hard adjacent matrix.
 => giảm thiểu thao tác tổng hợp thông tin nút dư thừa vô ích của Graph module.
  Gồm hai phần chính:
    - Graph Learning: Nhận đầu vào là một vector V, có các giá trị Vi là node thứ i trong đồ thị và khởi tạo giastrij V bằng với X0, Graph Module sinh ra một ma trận kề A biểu diễn mối quan hệ giữa 2 nodes đầu tiên cho qua Graph Learning và ma trận H được trích xuất cho mỗi node Vi sử dụng một mạng multi-layer perceptron(MLP), nhận đầu vào là V và vector α embbeding từ mối quan hệ tương ứng giữa các nodes. Sau đó đưa ma trận H qua mạng Graph Convolutional và biểu diễn chúng thành V'.
  -  Graph Convolutional: GNN có nhiệm vụ biểu diễn thông tin và bố cục của các nodes. Biểu diễn garph convolutional theo node-edge-node(vi,ại,vj). Sau đó tính ra các đặc trưng ẩn từ graph sử dụng bộ ba node-edge-node trên. Cuối cùng, tổng hợp thông tin từ các đặc trưng ẩn và ma trận kề A sử dụng graph convolutional để cập nhập các node.
 
 **Decoder**
  Nhận đầu vào là sự kết hợp giữa đầu ra của Encoder và Graph Module. Cho qua một mạng BiLSTM layer và CRF layer để phân loại chúng. 
  Cuối cùng mô hình sử dụng 2 hàm los để tối ưu đồng thời chúng, đó là loss của Graph learning và CRF loss.
 
