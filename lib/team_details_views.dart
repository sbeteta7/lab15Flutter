import 'package:flutter/material.dart';
import 'package:lab14/team.dart';
import 'package:lab14/team_database.dart';
import 'package:intl/intl.dart';

class TeamDetailsView extends StatefulWidget {
  final int? teamId;

  const TeamDetailsView({Key? key, this.teamId}) : super(key: key);

  @override
  _TeamDetailsViewState createState() => _TeamDetailsViewState();
}

class _TeamDetailsViewState extends State<TeamDetailsView> {
  TeamDatabase teamDatabase = TeamDatabase.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController dateChampController = TextEditingController();

  late TeamModel team;
  bool isLoading = false;
  bool isNewTeam = true;

  @override
  void initState() {
    super.initState();
    if (widget.teamId != null) {
      refreshTeam();
      isNewTeam = false;
    }
  }

  void refreshTeam() {
    teamDatabase.read(widget.teamId!).then((value) {
      setState(() {
        team = value;
        nameController.text = team.name;
        yearController.text = team.year.toString();
        dateChampController.text =
            DateFormat('yyyy-MM-dd').format(team.dateChamp!);
      });
    });
  }

  void createOrUpdateTeam() {
    setState(() {
      isLoading = true;
    });
    final model = TeamModel(
      name: nameController.text,
      year: yearController.text,
      dateChamp: DateTime.parse(dateChampController.text),
    );

    if (isNewTeam) {
      teamDatabase.create(model).then((createdTeamId) {
        print('Equipo creado con ID: $createdTeamId');
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      });
    } else {
      model.id = team.id;
      teamDatabase.update(model).then((value) {
        print('Equipo actualizado con ID: ${model.id}');
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      });
    }
  }

  void deleteTeam() {
    teamDatabase.delete(widget.teamId!);
    Navigator.pop(context);
  }

  void cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          Visibility(
            visible: !isNewTeam,
            child: IconButton(
              onPressed: deleteTeam,
              icon: const Icon(Icons.delete),
            ),
          ),
          IconButton(
            onPressed: createOrUpdateTeam,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Nombre del equipo...',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: yearController,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Año de fundación...',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: dateChampController,
                      cursorColor: Colors.white,
                      readOnly: true,
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 5),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            dateChampController.text =
                                DateFormat('yyyy-MM-dd').format(selectedDate);
                          });
                        }
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Fecha del campeonato...',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: cancel,
        tooltip: 'Cancelar',
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
