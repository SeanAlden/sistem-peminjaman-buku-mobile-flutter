import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/api_url.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/color.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({Key? key}) : super(key: key);

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  List loans = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchLoans();
  }

  Future<void> fetchLoans() async {
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await http.get(
        Uri.parse('$baseurl/api/loans'),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      final data = json.decode(response.body);

      if (data["success"] == true) {
        if (!mounted) return;
        setState(() {
          loans = data["data"];
        });
      }
    } catch (e) {
      debugPrint("Gagal ambil data peminjaman: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengambil data peminjaman")),
      );
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> requestReturn(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await http.post(
        Uri.parse('$baseurl/api/loans/$id/request-return'),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      final data = json.decode(response.body);

      if (data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Permintaan pengembalian dikirim. Serahkan buku ke admin.",
            ),
          ),
        );
        fetchLoans();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengajukan pengembalian buku")),
      );
    }
  }

  Future<void> cancelLoan(int id) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin membatalkan peminjaman ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              try {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString("auth_token");

                await http.delete(
                  Uri.parse('$baseurl/api/loans/$id'),
                  headers: {
                    "Authorization": "Bearer $token",
                    "Accept": "application/json",
                  },
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Peminjaman dibatalkan")),
                );
                fetchLoans();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Gagal membatalkan peminjaman")),
                );
              }
            },
            child: const Text("Ya"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Screen',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: orangeThemeColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "📖 Daftar Peminjaman Saya",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: loans.isEmpty
                          ? const Center(
                              child: Text(
                                "Anda belum memiliki riwayat peminjaman.",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: loans.length,
                              itemBuilder: (context, index) {
                                return LoanCard(
                                  item: loans[index],
                                  onReturn: requestReturn,
                                  onCancel: cancelLoan,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class LoanCard extends StatelessWidget {
  final dynamic item;
  final Function(int) onReturn;
  final Function(int) onCancel;

  const LoanCard({
    Key? key,
    required this.item,
    required this.onReturn,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final book = item["book"];
    final imageUrl = book["image_url"];

    final loanDate = DateFormat.yMd().format(DateTime.parse(item["loan_date"]));
    final maxReturnDate =
        DateFormat.yMd().format(DateTime.parse(item["max_returned_at"]));

    final returnDate = item["return_date"] != null
        ? DateFormat.yMd().format(DateTime.parse(item["return_date"]))
        : "-";

    final actualReturnedAt = item["actual_returned_at"] != null
        ? DateFormat.yMd().format(DateTime.parse(item["actual_returned_at"]))
        : "-";

    Color statusColor;
    String statusText;

    switch (item["status"]) {
      case "borrowed":
        statusColor = Colors.orange;
        statusText = "Dipinjam";
        break;
      case "pending_return":
        statusColor = Colors.blue;
        statusText = "Menunggu Konfirmasi Admin";
        break;
      default:
        statusColor = Colors.green;
        statusText = "Sudah Dikembalikan";
    }

    Color noteColor;
    String noteText;
    switch (item["return_status_note"]) {
      case "Returned Earlier":
        noteColor = Colors.green;
        noteText = "Dikembalikan Lebih Awal";
        break;
      case "Returned On Time":
        noteColor = Colors.blue;
        noteText = "Tepat Waktu";
        break;
      case "Overdue":
        noteColor = Colors.red;
        noteText = "Dikembalikan Terlambat";
        break;
      default:
        noteColor = Colors.black;
        noteText = "-";
    }

    return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl == null || imageUrl.isEmpty
                  ? Image.asset(
                      "assets/avatar.png",
                      width: 90,
                      height: 90,
                      fit: BoxFit.contain,
                    )
                  : CachedNetworkImage(
                      imageUrl:
                          "https://cellar-c2.services.clever-cloud.com/book-image-bucket/$imageUrl",
                      width: 90,
                      height: 90,
                      fit: BoxFit.contain,
                      errorWidget: (_, __, ___) => Image.asset(
                        "assets/avatar.png",
                        width: 90,
                        height: 90,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book["title"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text("Dipinjam: $loanDate",
                      style: const TextStyle(color: Colors.grey)),
                  Text("Kembali Maks: $maxReturnDate",
                      style: const TextStyle(color: Colors.grey)),
                  Text("Tanggal Kembali: $returnDate",
                      style: const TextStyle(color: Colors.grey)),
                  Text("Tanggal Konfirmasi Admin: $actualReturnedAt",
                      style: const TextStyle(color: Colors.grey)),
                  Text("Keterlambatan Pengembalian: ${item["late_days"]} hari",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 138, 95),
                          fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      const Text(
                        "Note: ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                        child: Text(
                          noteText,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: noteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text(
                        "Status: ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Denda: ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                        child: Text(
                          item["fine_amount"] != null
                              ? "Rp ${item["fine_amount"]}"
                              : "Rp 0",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: item["fine_amount"] != null &&
                                    item["fine_amount"] > 0
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (item["status"] == "borrowed") ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () => onReturn(item["id"]),
                            child: const Text(
                              "Kembalikan",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () => onCancel(item["id"]),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ));
  }
}
