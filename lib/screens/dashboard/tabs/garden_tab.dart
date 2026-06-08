import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/widgets/common/plant_card.dart';

class GardenTab extends StatelessWidget {
  const GardenTab({super.key});

  @override
  Widget build(BuildContext context) {
    final plantsProvider = Provider.of<PlantsProvider>(context);

    return Scaffold(
      body: plantsProvider.userPlants.isEmpty
          ? const Center(child: Text('Aún no tienes plantas en tu jardín.'))
          : GridView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: plantsProvider.userPlants.length,
              itemBuilder: (context, index) {
                final plant = plantsProvider.userPlants[index];
                return PlantCard(
                  plant: plant,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.plantDetail);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addPlant);
        },
        icon: const Icon(Icons.add),
        label: const Text('Añadir Planta'),
      ),
    );
  }
}
