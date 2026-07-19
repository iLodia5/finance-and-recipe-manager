import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:finance_track/models/transaction.dart';

class FinanceBookService {
  static Future<List<String>> getBooks(String profileName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('finance_books_$profileName') ?? [];
  }

  static Future<void> addBook(String profileName, String bookName, {String currency = 'USD', String? date}) async {
    final prefs = await SharedPreferences.getInstance();
    final books = await getBooks(profileName);

    if (!books.contains(bookName)) {
      books.add(bookName);
      await prefs.setStringList('finance_books_$profileName', books);
    }
    await prefs.setString('finance_book_currency_${profileName}_$bookName', currency);
    if (date != null) {
      await prefs.setString('finance_book_date_${profileName}_$bookName', date);
    }
  }

  static Future<String> getBookCurrency(String profileName, String bookName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('finance_book_currency_${profileName}_$bookName') ?? 'USD';
  }
  
  static Future<String?> getBookDate(String profileName, String bookName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('finance_book_date_${profileName}_$bookName');
  }

  static Future<void> removeBook(String profileName, String bookName) async {
    final prefs = await SharedPreferences.getInstance();
    final books = await getBooks(profileName);

    books.remove(bookName);
    await prefs.setStringList('finance_books_$profileName', books);
    await prefs.remove('transactions_${profileName}_$bookName');
  }

  static Future<List<Transaction>> getTransactions(String profileName, String bookName) async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('transactions_${profileName}_$bookName');
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Transaction.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveTransactions(
    String profileName,
    String bookName,
    List<Transaction> transactions,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(
      transactions.map((t) => t.toJson()).toList(),
    );
    await prefs.setString('transactions_${profileName}_$bookName', jsonString);
  }
}
