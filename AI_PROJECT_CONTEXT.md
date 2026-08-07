# AI PROJECT CONTEXT — submit

Cập nhật: 2026-08-08

## Mục đích file này

Đây là file đọc đầu tiên khi AI/ChatGPT vào sửa repo `hothequangvu241091-ai/submit`.
Không cần quét lại toàn bộ repo trước các thay đổi nhỏ nếu thông tin dưới đây vẫn còn đúng.

## Mục tiêu dự án

Hệ thống tự động submit URL lên Google Search Console bằng nhiều Microsoft Edge profile.
Luồng chính:

`URL -> xác định domain -> tìm Gmail quản lý domain -> tìm Edge profile -> mở đúng Search Console property -> kiểm tra URL -> yêu cầu lập chỉ mục -> đọc kết quả -> cập nhật trạng thái`.

## File quan trọng

- `_he_thong/manage_submit_edge_profiles.ps1`
  - GUI chính của chương trình.
  - Quản lý Gmail, domain, Edge profile.
  - Hiển thị danh sách URL.
  - Nạp URL, sửa trạng thái, submit tự động, dừng, xóa URL.
  - Phần lớn yêu cầu chỉnh UI sẽ sửa file này.

- `_he_thong/auto_submit_queue.py`
  - Bộ xử lý hàng đợi submit tự động.
  - Điều phối URL và trạng thái khi chạy.

- `_he_thong/cdp_fill_search_console_url.py`
  - Điều khiển Search Console qua CDP để nhập URL và thao tác kiểm tra URL.

- `_he_thong/cdp_watch_indexing_result.py`
  - Theo dõi/đọc kết quả lập chỉ mục.

- `_he_thong/open_submit_edge_profile.ps1`
  - Mở đúng Edge profile với cổng DevTools riêng.

- `_he_thong/submit_edge_profiles.json`
  - Dữ liệu Gmail/domain/profile.

- `_he_thong/submit_url_history.json`
  - Danh sách URL và trạng thái hiện tại.

- `_he_thong/auto_submit_progress.json`
  - Tiến trình của phiên submit tự động hiện tại/gần nhất.

- `QUAN_LY_PROFILE_SUBMIT.bat`
  - File người dùng mở để chạy GUI chính.

## Giao diện chính

GUI có 2 khu vực chính:

1. `SUBMIT URL`
2. `THIẾT LẬP GMAIL & PROFILE`

Trong `SUBMIT URL` có:

- ô tìm URL/domain
- nút `SUBMIT`
- nút `MỞ GSC`
- danh sách URL đã lưu
- panel URL đang chọn
- `SUBMIT TỰ ĐỘNG`
- `DỪNG AN TOÀN`
- `DỪNG NGAY`
- `NẠP THÊM URL`
- `XEM / SỬA`
- `XÓA TOÀN BỘ URL`

## Quy tắc UI đang áp dụng

Các nút thao tác chính phía dưới màn hình SUBMIT URL phải nằm cùng một hàng, không được đè lên ListBox/danh sách URL.

Thứ tự mong muốn:

`SUBMIT TỰ ĐỘNG | DỪNG AN TOÀN | DỪNG NGAY | NẠP THÊM URL | XEM / SỬA | XÓA TOÀN BỘ URL`

Nút xóa toàn bộ URL phải dễ nhìn, màu/viền đỏ và nằm ngoài cùng bên phải.

## Chức năng xóa toàn bộ URL

Nút hiện dùng biến:

`$deleteExternalUrlButton`

Tên hiển thị mong muốn:

`XÓA TOÀN BỘ URL`

Khi bấm:

1. Nếu danh sách trống thì không làm gì nguy hiểm.
2. Nếu có URL thì hỏi xác nhận Yes/No.
3. Khi Yes: đặt `$script:urlEntries = @()`.
4. Gọi `Save-UrlEntries` để ghi file rỗng.
5. `Save-UrlEntries` tự tạo bản `.bak` trước khi ghi nếu file cũ tồn tại.
6. Gọi `Refresh-UrlGrid` để cập nhật UI.

Không xóa Gmail/domain/profile khi dùng nút này.

## Trạng thái URL chính

- `PENDING` = CHƯA SUBMIT
- `PRIORITY` = ƯU TIÊN CHẠY TRƯỚC
- `RUNNING` = ĐANG SUBMIT
- `SUBMITTED` = HOÀN THÀNH
- `ERROR` = LỖI
- `QUOTA` = VƯỢT HẠN NGẠCH
- `SKIPPED` = BỎ QUA
- `UNMAPPED` = KHÔNG TÌM THẤY PROFILE

## Nguyên tắc sửa dự án

- Mặc định mọi yêu cầu trong task liên quan repo này là sửa trực tiếp trong repo `hothequangvu241091-ai/submit`.
- Trước thay đổi nhỏ, đọc `AI_PROJECT_CONTEXT.md` này trước.
- Chỉ đọc sâu file liên quan đến yêu cầu hiện tại, không cần quét lại toàn bộ dự án.
- Không viết lại toàn bộ hệ thống nếu chỉ cần sửa một chức năng/UI nhỏ.
- Giữ nguyên logic đang chạy nếu người dùng chỉ yêu cầu chỉnh giao diện.
- Không tự xóa dữ liệu Gmail/domain/profile.
- Với thao tác phá hủy dữ liệu URL, phải có xác nhận trước khi xóa.
- Sau khi sửa, cập nhật file này nếu cấu trúc, file chính hoặc hành vi quan trọng thay đổi.

## Việc đang chỉnh gần nhất

Yêu cầu: sửa vị trí nút `XÓA TOÀN BỘ URL` vì trước đây nó được đặt ở `buttonY - 40`, làm nút chồng/lọt vào vùng danh sách URL.

Mục tiêu mới: đặt 6 nút thao tác cuối cùng trên cùng một hàng và tự chia chiều rộng theo kích thước cửa sổ.
