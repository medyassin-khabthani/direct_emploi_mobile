import 'package:direct_emploi/helper/style.dart';
import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final String? title;
  final int? actif;
  final String date;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onToggleActif;

  const AlertCard({
    Key? key,
    required this.title,
    required this.date,
    required this.onTap,
    required this.onDelete,
    required this.onToggleActif,
    this.actif,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: actif == 1 ? 1.0 : 0.5,
      child: InkWell(
        hoverColor: Colors.white,
        focusColor: Colors.white,
        highlightColor: Colors.white,
        splashColor: Colors.white,
        onTap: onTap,
        child: Card(
          margin: EdgeInsets.only(bottom: 20),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(color: strokeColor, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      actif == 1 ? "$date - activé" : "$date - Désactivé",
                      style: TextStyle(color: paragraphColor, fontSize: 12),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      title!,
                      style: TextStyle(fontFamily: "medium", fontSize: 14),
                    )
                  ],
                ),
                PopupMenuButton<int>(
                  onSelected: (value) {
                    if (value == 0) {
                      onToggleActif();
                    } else if (value == 1) {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      child: Text(actif == 1
                          ? 'Rendre désactivé'
                          : 'Rendre activé'),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Text('Supprimer'),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
