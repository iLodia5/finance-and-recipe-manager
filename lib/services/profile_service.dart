import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:finance_track/models/transaction.dart';

class ProfileService {
  static const String _profilesKey = 'user_profiles';

  static Future<List<String>> getProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_profilesKey) ?? [];
  }

  static Future<void> addProfile(String name, {String currency = 'USD'}) async {
    final prefs = await SharedPreferences.getInstance();
    final profiles = await getProfiles();

    // Only add if it doesn't already exist
    if (!profiles.contains(name)) {
      profiles.add(name);
      await prefs.setStringList(_profilesKey, profiles);
    }
    await prefs.setString('profile_currency_$name', currency);
  }

  static Future<String> getProfileCurrency(String name) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_currency_$name') ?? 'USD';
  }

  static Future<void> removeProfile(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final profiles = await getProfiles();

    profiles.remove(name);
    await prefs.setStringList(_profilesKey, profiles);
    await prefs.remove('transactions_$name'); // Also clean up transactions
  }

  static Future<List<Transaction>> getTransactions(String profileName) async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('transactions_$profileName');
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
    List<Transaction> transactions,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(
      transactions.map((t) => t.toJson()).toList(),
    );
    await prefs.setString('transactions_$profileName', jsonString);
  }
}
