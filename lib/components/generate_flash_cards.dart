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

  String text = "";

  List<Map<String, String>> flashcards = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> generateFlashcards() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      List<Map<String, String>> result = await sendOpenAiRequest(getPDFtext());
      setState(() {
        flashcards = result;
      });
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
  Future<String> getPDFtext() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null){
      File file = File(result.files.single.path!);
      try {
        text = await ReadPdfText.getPDFtext(file.path);
      } on PlatformException {
        print('Failed to get PDF text.');
      }
    }
    return text;
  }

  //Contact openAI
  Future sendOpenAiRequest(data) async {
    final apiKey = dotenv.env["API_KEY"];
    final url = Uri.parse("https://api.openai.com/v1/completions");
    String prompt = "Generate flashcards from the text provided at the end of this prompt. Ignore any content tables, footers or front pages contained within the text. Each flashcard should have a front and a back, the output should be in json format. Make sure there is an appropriate number of cards for the content provided. The text is as follow: $data";

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-4-turbo',
          'prompt': prompt,
          'max_tokens': 500,
          'temperature': 0.7
        }),
      );


    if (response.statusCode == 200) {
      print("working 1");
      // Parse and handle the response.
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Extract flashcards from the first choice
      final List<dynamic> choices = responseData['choices'];
      print(choices);
      final String textResponse = choices[0]['text'];

      // Split the text into question-answer pairs
      List<String> rawFlashcards = textResponse.split("\n\n");
      List<Map<String, String>> parsedFlashcards = [];

      for (String flashcard in rawFlashcards) {
        List<String> parts = flashcard.split("\n");
        if (parts.length >= 2) {
          parsedFlashcards.add({'question': parts[0], 'answer': parts[1]});
        }
      }
      print(parsedFlashcards);
      return parsedFlashcards;

    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response: ${response.body}');
    }
    return jsonDecode(response.body);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Flashcards')),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : errorMessage != null
                ? Text('Error: $errorMessage', style: TextStyle(color: Colors.red))
                : flashcards.isEmpty
                    ? Text('No flashcards yet. Tap the button to generate!')
                    : ListView.builder(
                        itemCount: flashcards.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(flashcards[index]['question'] ?? 'No question'),
                              subtitle: Text(flashcards[index]['answer'] ?? 'No answer'),
                            ),
                          );
                        },
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: generateFlashcards,
        child: Icon(Icons.flash_on),
      ),
    );
  }
}