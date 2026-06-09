import 'package:flutter/material.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/common/custom_button.dart';

class ScannerTab extends StatelessWidget {
  const ScannerTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Identificación de Plantas',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Apunta con la cámara a la planta o sube una foto de tu galería para diagnosticarla.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Viewfinder Card
          Card(
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: AspectRatio(
              aspectRatio: 1.2,
              child: Stack(
                children: [
                  // Scan preview image
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/ai_scan_preview.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Corner framing brackets (Overlay)
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Stack(
                        children: [
                          // Top-Left corner
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: AppColors.accent, width: 3),
                                  left: BorderSide(color: AppColors.accent, width: 3),
                                ),
                              ),
                            ),
                          ),
                          // Top-Right corner
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: AppColors.accent, width: 3),
                                  right: BorderSide(color: AppColors.accent, width: 3),
                                ),
                              ),
                            ),
                          ),
                          // Bottom-Left corner
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: AppColors.accent, width: 3),
                                  left: BorderSide(color: AppColors.accent, width: 3),
                                ),
                              ),
                            ),
                          ),
                          // Bottom-Right corner
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: AppColors.accent, width: 3),
                                  right: BorderSide(color: AppColors.accent, width: 3),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Scanning Laser Line Animation
                  const Positioned.fill(
                    child: _ScanningLaserLine(),
                  ),
                  // Center Scanner Tag
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Listo para Escanear',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Scanning action buttons
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Hacer Foto',
                  icon: Icons.camera_alt,
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Abriendo cámara para diagnóstico... 📸'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'Subir de Galería',
                  icon: Icons.photo_library,
                  isOutlined: true,
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Abriendo galería... 🖼️'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Recent analyses
          Text(
            'Análisis Recientes',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          _buildRecentAnalysisItem(
            context,
            'Monstera Deliciosa',
            '98% de coincidencia • Muy saludable',
            'Hace 2 horas',
            Icons.eco,
          ),
          const SizedBox(height: 10),
          _buildRecentAnalysisItem(
            context,
            'Poto (Epipremnum aureum)',
            '94% de coincidencia • Requiere riego',
            'Ayer',
            Icons.local_florist,
          ),

          const SizedBox(height: 100), // Padding for bottom navbar
        ],
      ),
    );
  }

  Widget _buildRecentAnalysisItem(
    BuildContext context,
    String title,
    String subtitle,
    String time,
    IconData icon,
  ) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.textMuted.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        trailing: Text(
          time,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

class _ScanningLaserLine extends StatefulWidget {
  const _ScanningLaserLine();

  @override
  State<_ScanningLaserLine> createState() => _ScanningLaserLineState();
}

class _ScanningLaserLineState extends State<_ScanningLaserLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Align(
              alignment: Alignment(0, (_controller.value * 2) - 1),
              child: Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.8),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent.withValues(alpha: 0.0),
                      AppColors.accent,
                      AppColors.accent,
                      AppColors.accent.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.4, 0.6, 1.0],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
