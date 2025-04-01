import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:read_pdf_text/read_pdf_text.dart';

Future<List> generateFlashCards() async {
    final apiKey = dotenv.env["API_KEY"];
    String text = "";
    List<List<String>> flashcards = [];

    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null){
      File file = File(result.files.single.path!);
      try {
        text = await ReadPdfText.getPDFtext(file.path);
      } on PlatformException {
        throw('Failed to get PDF text.');
      }
    }

    String prompt = "Generate flashcards from the text provided at the end of this prompt. Ignore any content tables, footers or front pages contained within the text. Each flashcard should have a front and a back. Make sure there is an appropriate number of cards for the content provided. The output should be formatted as follows '{'front': example text, 'back': example text} {'front': example two, 'back': example two}' The text is as follow: $text";
    
    var flashcardsResponse = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content': 'You are an assistant that converts PDF content into flashcards.'
          },
          {
            'role': 'user',
            'content': prompt
          },
        ],
        'max_tokens': 500,
        'temperature': 0.7,
      }),
    );


    if (flashcardsResponse.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(flashcardsResponse.body);
      String result = responseData['choices'].toString();
      result = result.substring(47);
      RegExp regExp = RegExp(r"\{'front': '(.*?)', 'back': '(.*?)\'}");
      for (RegExpMatch match in regExp.allMatches(result)) {
        String front = match.group(1)?.trim() ?? "";
        String back = match.group(2)?.trim() ?? "";
        flashcards.add([front, back]);
      }
      print(flashcards);
      return flashcards;
    } 
    else {
      throw('Request failed with status: ${flashcardsResponse.statusCode}');
    }
}