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
      List result = await getPDFtext();
      print("This is the output ${result[0].toString().substring(65)}");
      //final data = result[0].toString().substring(65);
      //print(data);

      //final split = data.split('front:');
      //final Map<int, String> values = {
//for (int i = 0; i < split.length; i++)
//i: split[i]
      //};
     // print(values);
      setState(() {
        //flashcards = data;
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
  Future<List> getPDFtext() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null){
      File file = File(result.files.single.path!);
      try {
        text = await ReadPdfText.getPDFtext(file.path);
      } on PlatformException {
        print('Failed to get PDF text.');
      }
    }
    return sendOpenAiRequest(text);
  }

  //Contact openAI
  Future<List> sendOpenAiRequest(data) async {
    final apiKey = dotenv.env["API_KEY"];
    String prompt = "Generate flashcards from the text provided at the end of this prompt. Ignore any content tables, footers or front pages contained within the text. Each flashcard should have a front and a back. Make sure there is an appropriate number of cards for the content provided. The output should be formatted as follows 'front: example text, back: example text: front: example two, back: example two:' The text is as follow: $data";

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
      // Extract flashcards from the first choice
      final List<dynamic> choices = responseData['choices'];
      return choices;
      /*print("This is the choices $choices");
      //final String textResponse = choices[1]['text'];

      // Split the text into question-answer pairs
      List<String> rawFlashcards = choices[0].split("\n\n");
      List<Map<String, String>> parsedFlashcards = [];

      for (String flashcard in rawFlashcards) {
        List<String> parts = flashcard.split("\n");
        if (parts.length >= 2) {
          parsedFlashcards.add({'question': parts[0], 'answer': parts[1]});
        }
      }
      print(parsedFlashcards);
      return parsedFlashcards;
*/
    } else {
      print('Request failed with status: ${flashcardsResponse.statusCode}');
      print('Response: ${flashcardsResponse.body}');
    }
    return jsonDecode(flashcardsResponse.body);
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