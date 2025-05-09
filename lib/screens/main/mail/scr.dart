import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:omni_chat/apis/mail/controllers/reply.dart';
import 'package:omni_chat/apis/mail/controllers/respond_email.dart';
import 'package:omni_chat/widgets/button/common_btn.dart';
import 'package:omni_chat/widgets/text/input_field.dart';
import 'package:omni_chat/widgets/text/input_header.dart';

class MailComposerScreen extends StatefulWidget {
  const MailComposerScreen({super.key});

  @override
  State<MailComposerScreen> createState() => _MailComposerScreenState();
}

class _MailComposerScreenState extends State<MailComposerScreen> {
  final TextEditingController senderCtrlr = TextEditingController();
  final TextEditingController receiverCtrlr = TextEditingController();
  final TextEditingController subjectCtrlr = TextEditingController();
  final TextEditingController contentCtrlr = TextEditingController();

  final List<bool> selectedLanguage = <bool>[true, false];
  final ValueNotifier<bool> generating = ValueNotifier(false);

  @override
  void dispose() {
    senderCtrlr.dispose();
    receiverCtrlr.dispose();
    subjectCtrlr.dispose();
    contentCtrlr.dispose();
    super.dispose();
  }

  Future<void> onReply() async {
    generating.value = true;
    await replyEmail((
      sender: "TT Hỗ trợ sinh viên Trường ĐH Khoa học Tự nhiên, ĐHQG-HCM",
      receiver: "tthotrosinhvien@hcmus.edu.vn",
      subject: "ĐĂNG KÝ “NGÀY HỘI SINH VIÊN VÀ DOANH NGHIỆP - NĂM 2024",
      content:
          "Các bạn sinh viên thân mến, Trung tâm Hỗ trợ Sinh viên giới thiệu tới các bạn “Ngày Hội Sinh viên và Doanh nghiệp - Năm 2024” - Ngày hội việc làm là dịp để cho Sinh viên gặp gỡ, giao lưu, kết nối và tìm kiếm cơ hội việc làm ở rất nhiều lĩnh vực ngành nghề. Chương trình được tổ chức bởi Trung tâm Hỗ trợ sinh viên Trường Đại học Khoa học tự nhiên, ĐHQG-HCM dưới sự chỉ đạo của BGH Nhà trường. Thời gian: 7g30 ngày 03/11/2024 (Chủ nhật) Địa điểm: Sân trường Đại học Khoa học Tự nhiên, ĐHQG-HCM cơ sở 2 - Linh Trung, Khu đô thị Đại học Quốc gia tại Thành phố Thủ Đức. ______________________ Năm nay, “Ngày hội Sinh viên và Doanh nghiệp năm 2024\" mang đến cho bạn: 28 Doanh nghiệp tham gia; 30 Sàn dịch vụ - việc làm; 200 Công việc full time/part time; 17 Gian hàng dịch vụ thầy cô, sinh viên, CLB - Đội - Nhóm; 02 Chương trình, hội thảo kỹ năng - hướng nghiệp dành cho các bạn sinh viên; 10 Địa điểm phỏng vấn cực HOT. Bên cạnh đó, Ngày hội mang tới hơn 1000 món quà hấp dẫn như: balo, túi xách, áo polo,... Để đăng ký tham gia: Bước 1: Đăng kí theo link: https://docs.google.com/forms/d/e/1FAIpQLSc1uJXxOaXyEVs0YIj6pnWT0DM6b4dvlBGx89SCgAuAvF1KgA/viewform Bước 2: Nhận vé mời tại Trung tâm ở hai cơ sở. Nếu bạn không có thời gian có thể nhận tại cổng Ngày hội, ngày 03/11/2024 !!! Đây là hoạt động có tính điểm rèn luyện nhé!!! Chi tiết ngày Hội xem tại: Hẹn gặp các bạn ở “Ngày hội Sinh viên và Doanh nghiệp - Năm 2024\" vào ngày 03/11/2024 ________________________________ Mọi thông tin liên hệ TRUNG TÂM HỖ TRỢ SINH VIÊN Email: tthotrosinhvien@hcmus.edu.vn Website: sacus.vn Tel: 028 38 320 287",
      onError: () {
        generating.value = false;
      },
    ));
    generating.value = false;
  }

  Future<void> onRespond() async {
    generating.value = true;
    respondEmail((
      onError: () {
        generating.value = false;
      },
    ));
    generating.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mail Composer"),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                InputHeader(title: "Sender", isRequired: true),
                InputField(
                  controller: senderCtrlr,
                  placeholder: "Sender",
                  fontSz: 14,
                ),
                InputHeader(title: "Receiver", isRequired: true),
                InputField(
                  controller: receiverCtrlr,
                  placeholder: "someone@example.com",
                  fontSz: 14,
                ),
                InputHeader(title: "Subject", isRequired: true),
                InputField(
                  controller: subjectCtrlr,
                  placeholder: "Topics or subjects to be discussed",
                  fontSz: 14,
                ),
                InputHeader(title: "Content", isRequired: true),
                InputField(
                  controller: contentCtrlr,
                  placeholder:
                      "Content of the email you want to be replied or responsed",
                  isNewLineAction: true,
                  fontSz: 14,
                  minLns: 10,
                  maxLns: 15,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: generating,
                  builder: (context, loading, _) {
                    return loading
                        ? Align(
                          alignment: Alignment.center,
                          child: Lottie.asset(
                            "assets/anims/loading.json",
                            width: 150,
                            height: 100,
                          ),
                        )
                        : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: CommonBtn(
                            title: "Generate",
                            onTap: () async {
                              onReply();
                              onRespond();
                            },
                          ),
                        );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
