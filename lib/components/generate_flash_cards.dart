import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

class GenerateFlashCards extends StatefulWidget {
  const GenerateFlashCards({super.key});

  @override
  State<GenerateFlashCards> createState() => _GenerateFlashCardsState();
}

class _GenerateFlashCardsState extends State<GenerateFlashCards> {
  List<List<String>> flashcards = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> generateFlashcards() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      String result = await convertPDFAndSendRequest();

      //Parse data from API into a matrix. 
      result = result.substring(47);
      RegExp regExp = RegExp(r"\{'front': (.*?), 'back': (.*?)\}");
      for (RegExpMatch match in regExp.allMatches(result)) {
        String front = match.group(1)?.trim() ?? "";
        String back = match.group(2)?.trim() ?? "";
        flashcards.add([front, back]);
      }

      setState(() {});
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //Extract all text from PDF
  Future <String> convertPDFAndSendRequest() async {
    String text = "";
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null){
      File file = File(result.files.single.path!);
      try {
        text = await ReadPdfText.getPDFtext(file.path);
      } on PlatformException {
        return('Failed to get PDF text.');
      }
    }
    return sendOpenAiRequest(text);
  }

  //Contact openAI
  Future <String> sendOpenAiRequest(data) async {
    final apiKey = dotenv.env["API_KEY"];
    String prompt = "Generate flashcards from the text provided at the end of this prompt. Ignore any content tables, footers or front pages contained within the text. Each flashcard should have a front and a back. Make sure there is an appropriate number of cards for the content provided. The output should be formatted as follows '{'front': example text, 'back': example text} {'front': example two, 'back': example two}' The text is as follow: $data";

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
      // Parse and handle the response.
      final Map<String, dynamic> responseData = jsonDecode(flashcardsResponse.body);
      String choices = responseData['choices'].toString();
      return choices;
    } 
    else {
      return('Request failed with status: ${flashcardsResponse.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flashcard Generation")),
      body: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : errorMessage != null
                    ? Text("Error: $errorMessage", style: TextStyle(color: Colors.red))
                    : flashcards.isEmpty
                        ? Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Text("Please only upload a PDF Document and wait a few moments for your flashcards to be generated", textAlign: TextAlign.center),
                        )
                        : ListView.builder(
                            itemCount: flashcards.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(flashcards[index][0]),
                                  subtitle: Text(flashcards[index][1]),
                                ),
                              );
                            },
                          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Center(
            child: GestureDetector(
              onTap: generateFlashcards,
              child: Text("Click here to upload your PDF", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          )
        ),
    );
  }
}