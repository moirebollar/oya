import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oya/l10n/app_localizations.dart';
import 'package:oya/core/theme/app_colors.dart';
import 'package:oya/features/store_finder/domain/sustainable_store.dart';

class StoreDetailScreen extends StatelessWidget {
  const StoreDetailScreen({super.key, required this.osmId});

  final String osmId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    // Stores are passed as GoRouter `extra`
    final allStores = GoRouterState.of(context).extra as List<SustainableStore>?;
    final store = allStores?.where((s) => s.osmId == osmId).firstOrNull;

    if (store == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l.errorGeneric)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(store.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Store icon header
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(Icons.store, size: 52, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 24),

          // Certifications
          if (store.isOrganic || store.isZeroWaste) ...[
            Text(l.storesDetailCertifications,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13,
                    color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              if (store.isOrganic)
                Chip(
                  avatar: const Icon(Icons.eco, size: 16, color: AppColors.primary),
                  label: Text(l.storesCertOrganic),
                ),
              if (store.isZeroWaste)
                Chip(
                  avatar: const Icon(Icons.recycling, size: 16,
                      color: AppColors.primary),
                  label: Text(l.storesCertZeroWaste),
                ),
            ]),
            const SizedBox(height: 20),
          ],

          // Address
          if (store.address != null) ...[
            _DetailRow(
              icon: Icons.location_on_outlined,
              label: l.storesDetailAddress,
              value: store.address!,
            ),
            const SizedBox(height: 16),
          ],

          // Opening hours
          if (store.openingHours != null) ...[
            _DetailRow(
              icon: Icons.schedule_outlined,
              label: l.storesDetailHours,
              value: store.openingHours!,
            ),
            const SizedBox(height: 16),
          ],

          const Divider(),
          const SizedBox(height: 8),
          Text(l.storesMapAttribution,
              style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
