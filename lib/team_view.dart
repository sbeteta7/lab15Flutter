import 'package:flutter/material.dart';
import 'package:lab14/team.dart';
import 'package:lab14/team_database.dart';
import 'package:lab14/team_details_views.dart';

class TeamsView extends StatefulWidget {
  const TeamsView({Key? key}) : super(key: key);

  @override
  State<TeamsView> createState() => _TeamsViewState();
}

class _TeamsViewState extends State<TeamsView> {
  TeamDatabase teamDatabase = TeamDatabase.instance;
  List<TeamModel> teams = [];

  @override
  void initState() {
    refreshTeams();
    super.initState();
  }

  @override
  void dispose() {
    // Close the database
    teamDatabase.close();
    super.dispose();
  }

  /// Gets all the teams from the database and updates the state
  void refreshTeams() {
    teamDatabase.readAll().then((value) {
      setState(() {
        teams = value;
      });
    });
  }

  /// Navigates to the TeamDetailsView and refreshes the teams after the navigation
  void goToTeamDetailsView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TeamDetailsView(teamId: id)),
    );
    refreshTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: teams.isEmpty
            ? const Text(
                'No hay equipos registrados. Crea un nuevo equipo!',
                style: TextStyle(color: Colors.white),
              )
            : ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  final team = teams[index];
                  return GestureDetector(
                    onTap: () => goToTeamDetailsView(id: team.id),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Equipo ID: ${team.id}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                team.name,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Text(
                                'Año: ${team.year}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Fecha Campeonato: ${team.dateChamp}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToTeamDetailsView(),
        tooltip: 'Crear Equipo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
