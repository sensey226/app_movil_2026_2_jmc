import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const ReparaTodoApp());

class ReparaTodoApp extends StatelessWidget {
  const ReparaTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Repara Todo',
      theme: ThemeData(
        useMaterial3: true,
        // Configuración de paleta Azul y Negro
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A2540), // Azul oscuro/marino
          brightness: Brightness.dark,       // Tema en modo oscuro (Negro)
          surface: const Color(0xFF121212),  // Fondo negro
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      home: const RegistroPage(),
    );
  }
}

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  // GlobalKey y controladores por campo
  final _keyForm = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _dniController = TextEditingController();
  final _celularController = TextEditingController();

  final Map<String, String> _datos = {};
  String _saludo = '';

  @override
  void dispose() {
    // Liberar controladores
    _nombreController.dispose();
    _correoController.dispose();
    _dniController.dispose();
    _celularController.dispose();
    super.dispose();
  }

  // Validación de correo
  String? _validarCorreo(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'El correo es obligatorio';
    }
    final regExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regExp.hasMatch(valor.trim())) {
      return 'Ingrese un correo válido (ej. usuario@dominio.ext)';
    }
    return null;
  }

  // Función de envío
  void _enviar() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Cliente ${_datos["nombre"]} registrado con éxito en Repara Todo!'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repara Todo - Registro'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _keyForm,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_saludo.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _saludo,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),

              // 1. Nombres y Apellidos
              TextFormField(
                controller: _nombreController,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ ]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Nombres y apellidos',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  if (valor.trim().length < 3) {
                    return 'Debe tener al menos 3 caracteres';
                  }
                  return null;
                },
                onChanged: (valor) {
                  setState(() {
                    _saludo = valor.trim().isNotEmpty ? 'Hola, ${valor.trim()}' : '';
                  });
                },
                onSaved: (valor) => _datos['nombre'] = valor?.trim() ?? '',
              ),
              const SizedBox(height: 16),

              // 2. Correo electrónico
              TextFormField(
                controller: _correoController,
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: _validarCorreo,
                onSaved: (valor) => _datos['correo'] = valor?.trim() ?? '',
              ),
              const SizedBox(height: 16),

              // 3. DNI
              TextFormField(
                controller: _dniController,
                keyboardType: TextInputType.number,
                maxLength: 8,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: 'DNI',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'El DNI es obligatorio';
                  }
                  if (valor.length != 8) {
                    return 'El DNI debe tener exactamente 8 dígitos';
                  }
                  return null;
                },
                onSaved: (valor) => _datos['dni'] = valor ?? '',
              ),
              const SizedBox(height: 16),

              // 4. Celular
              TextFormField(
                controller: _celularController,
                keyboardType: TextInputType.phone,
                maxLength: 9,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: 'Celular',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'El celular es obligatorio';
                  }
                  if (valor.length != 9) {
                    return 'El celular debe tener 9 dígitos';
                  }
                  if (!valor.startsWith('9')) {
                    return 'El celular debe empezar con 9';
                  }
                  return null;
                },
                onSaved: (valor) => _datos['celular'] = valor ?? '',
              ),
              const SizedBox(height: 24),

              // Botón Registrar
              FilledButton.icon(
                onPressed: _enviar,
                icon: const Icon(Icons.build), // Ícono de herramientas para Repara Todo
                label: const Text('Registrar cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}