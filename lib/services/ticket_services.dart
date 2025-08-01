import 'dart:convert';
import 'dart:math';

import 'package:orado_customer/features/ticket/model/raise_a_ticket_response_model.dart';
import 'package:orado_customer/features/ticket/model/send_reply_model.dart';
import 'package:orado_customer/features/ticket/model/ticket_detail_model.dart';
import 'package:orado_customer/features/ticket/model/tickets_model.dart';
import 'package:orado_customer/utilities/urls.dart';
import 'package:http/http.dart' as http;

import '../features/location/provider/location_provider.dart';

class TicketServices {
  static Future<TicketsModel?> getAllTickets() async {
    try {
      final url = Uri.parse("${Urls.baserUrl}tickets/my");

      final token = await LocationProvider.getToken();

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = TicketsModel.fromJson(json);

        return data;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<RaiseATicketResponseModel?> raiseATicket(
      {required String subject,
      required String priority,
      required String message}) async {
    try {
      final url = Uri.parse("${Urls.baserUrl}tickets/create");
      final token = await LocationProvider.getToken();

      final requestBody = jsonEncode(
          {"subject": subject, "priority": priority, "message": message});

      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: requestBody);

      final json = jsonDecode(response.body);

      print("${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = RaiseATicketResponseModel.fromJson(json);

        return data;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<TicketDetailModel?> getTicketDetails(
      {required String ticketId}) async {
    try {
      final url = Uri.parse("${Urls.baserUrl}tickets/my/$ticketId");
      final token = await LocationProvider.getToken();

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = TicketDetailModel.fromJson(json);

        return data;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<SendReplyModel?> sendTicketReply(
      {required String reply, required String ticketId}) async {
    try {
      final url = Uri.parse("${Urls.baserUrl}tickets/$ticketId/reply");
      final token = await LocationProvider.getToken();

      final requestBody = jsonEncode({"message": reply});

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: requestBody
      );

      final json = jsonDecode(response.body);

      print(response.body);

      if(response.statusCode == 201 || response.statusCode == 200){

        final data = SendReplyModel.fromJson(json);

        return data;

      }else{

        return null;

      }

    } catch (e) {
      rethrow;
    }
  }
}
