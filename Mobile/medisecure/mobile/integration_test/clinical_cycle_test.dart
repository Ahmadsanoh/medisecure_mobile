import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:medisecure/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Cycle Clinique End-to-End', () {
    testWidgets('Flux complet Infirmier -> Docteur', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. Connexion Infirmier
      // (Supposant que nous sommes sur l'écran de login)
      print('--- STEP 1: Login Nurse ---');
      final emailField = find.byType(TextField).first;
      final passField = find.byType(TextField).last;
      final loginBtn = find.text('Se connecter');

      await tester.enterText(emailField, 'nurse1@medisecure.com');
      await tester.enterText(passField, 'demo_password123');
      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueEmail = 'jean.e2e.$timestamp@test.com';

      // 2. Dashboard : Enregistrer un patient
      print('--- STEP 2: Register Patient ---');
      expect(find.text('Nouv. Patient'), findsOneWidget);
      await tester.tap(find.text('Nouv. Patient'));
      await tester.pumpAndSettle();

      // Remplir le modal
      print('--- STEP 3: Fill Registration Form ---');
      await tester.enterText(find.byType(TextField).at(0), 'Adama');
      await tester.enterText(find.widgetWithText(TextField, 'Nom'), 'E2E');
      await tester.enterText(
          find.widgetWithText(TextField, 'Email'), uniqueEmail);
      await tester.enterText(
          find.widgetWithText(TextField, 'Mot de passe temporaire'),
          'Pass123!');
      print('--- STEP 4: Submit Registration ---');
      await tester.tap(find.text('Créer le compte'));
      await tester.pumpAndSettle();

      // 3. Ouvrir le dossier du patient (via la liste ou recherche - ici on simplifie)
      // Navigate to Records
      await tester.tap(find.text('Patients'));
      await tester.pumpAndSettle();

      // On suppose que Jean E2E est le premier
      await tester.tap(find.textContaining('Jean E2E'));
      await tester.pumpAndSettle();

      // 4. Saisie des constantes
      final vitalsBtn = find.byIcon(Icons.speed_outlined);
      await tester.tap(vitalsBtn);
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Poids (kg)'), '80');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Température (°C)'), '37.5');
      await tester.tap(find.text('Enregistrer les constantes'));
      await tester.pumpAndSettle();

      // 5. Déconnexion
      // On clique sur le profil (dernier onglet du Shell)
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Déconnexion'));
      await tester.pumpAndSettle();

      // 6. Connexion Docteur
      await tester.enterText(emailField, 'doctor1@medisecure.com');
      await tester.enterText(passField, 'demo_password123');
      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      // 7. Vérification des constantes et Consultation
      await tester.tap(find.text('Patients'));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Jean E2E'));
      await tester.pumpAndSettle();

      // Ouvrir la section Signes Vitaux (Expandable)
      // ... logique additionnelle pour déplier

      expect(find.textContaining('80 kg'), findsWidgets);
    });
  });
}
