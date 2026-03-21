import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/subscription_provider.dart';

class SubscriptionScreen extends StatefulWidget {
  /// If true, user arrived here from a gated feature (show "Continue for free" option)
  final bool fromGate;

  const SubscriptionScreen({super.key, this.fromGate = false});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _showAnnual = true;
  // 0 = Heritage Keeper, 1 = Legacy Collection
  int _selectedTier = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionProvider>().loadSubscriptionStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sub = context.watch<SubscriptionProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? DarkColors.background : LightColors.background;
    final surface = isDark ? DarkColors.surface : LightColors.surface;
    final textPrimary = isDark ? DarkColors.textPrimary : LightColors.textPrimary;
    final textSecondary = isDark ? DarkColors.textSecondary : LightColors.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.fromGate
            ? TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Not now',
                  style: TextStyle(
                    color: textSecondary,
                    fontFamily: 'Manrope',
                    fontSize: 14,
                  ),
                ),
              )
            : IconButton(
                icon: Icon(Icons.close, color: textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
        actions: [
          TextButton(
            onPressed: sub.isRestoring ? null : () => _restore(context),
            child: Text(
              sub.isRestoring ? 'Restoring…' : 'Restore',
              style: TextStyle(
                color: brandPrimary,
                fontFamily: 'Manrope',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: sub.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(context, sub, surface, textPrimary, textSecondary, isDark),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SubscriptionProvider sub,
    Color surface,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ────────────────────────────────────────────────────
          const SizedBox(height: 8),
          Text(
            'Preserve Your\nFamily Legacy',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              fontFamily: 'Playfair Display',
              color: textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Unlock premium features to keep your family\'s\nrecipes alive for generations.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Manrope',
              color: textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),

          // ── Billing toggle ────────────────────────────────────────────
          _buildBillingToggle(textPrimary),
          const SizedBox(height: 24),

          // ── Tier cards ────────────────────────────────────────────────
          _buildTierCard(
            context,
            sub,
            surface,
            textPrimary,
            textSecondary,
            isDark,
            tierIndex: 0,
            name: 'Heritage Keeper',
            tagline: 'Perfect for getting started',
            monthlyPrice: '\$9.99',
            annualPrice: '\$99.99',
            annualMonthlyEquiv: '\$8.33',
            features: [
              'Unlimited family recipe storage',
              'Family sharing (up to 10 members)',
              'Photo uploads for every recipe',
              'Export & print recipe books',
              'Recipe categories & tags',
            ],
          ),
          const SizedBox(height: 16),
          _buildTierCard(
            context,
            sub,
            surface,
            textPrimary,
            textSecondary,
            isDark,
            tierIndex: 1,
            name: 'Legacy Collection',
            tagline: 'The complete family experience',
            monthlyPrice: '\$19.99',
            annualPrice: '\$199.99',
            annualMonthlyEquiv: '\$16.67',
            highlight: true,
            features: [
              'Everything in Heritage Keeper',
              'Unlimited family members',
              'Advanced recipe organization',
              'Priority customer support',
              'Early access to new features',
              'Custom family cookbook themes',
            ],
          ),
          const SizedBox(height: 28),

          // ── CTA Button ────────────────────────────────────────────────
          _buildCtaButton(context, sub),
          const SizedBox(height: 16),

          // ── Footer ────────────────────────────────────────────────────
          Text(
            'Subscriptions auto-renew until cancelled. Cancel anytime in your device settings.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'Manrope',
              color: textSecondary,
            ),
          ),

          // ── Error message ─────────────────────────────────────────────
          if (sub.errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                sub.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontFamily: 'Manrope',
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBillingToggle(Color textPrimary) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: LightColors.surfaceMuted,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: _showAnnual ? Alignment.centerRight : Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: brandPrimary,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _showAnnual = false),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'Monthly',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: _showAnnual ? textPrimary : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _showAnnual = true),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Annual',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: _showAnnual ? Colors.white : textPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _showAnnual
                                ? Colors.white.withOpacity(0.25)
                                : brandAccent.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Save ~17%',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _showAnnual ? Colors.white : brandAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTierCard(
    BuildContext context,
    SubscriptionProvider sub,
    Color surface,
    Color textPrimary,
    Color textSecondary,
    bool isDark, {
    required int tierIndex,
    required String name,
    required String tagline,
    required String monthlyPrice,
    required String annualPrice,
    required String annualMonthlyEquiv,
    required List<String> features,
    bool highlight = false,
  }) {
    final isSelected = _selectedTier == tierIndex;
    final borderColor = isSelected
        ? brandPrimary
        : highlight
            ? brandAccent
            : (isDark ? DarkColors.border : LightColors.border);

    return GestureDetector(
      onTap: () => setState(() => _selectedTier = tierIndex),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: brandPrimary.withOpacity(0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header bar
            if (highlight)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: brandAccent,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                child: const Text(
                  'MOST POPULAR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tier name + selected indicator
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Playfair Display',
                            color: textPrimary,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? brandPrimary : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? brandPrimary
                                : (isDark ? DarkColors.border : LightColors.border),
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 14)
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tagline,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Manrope',
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _showAnnual ? annualPrice : monthlyPrice,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Manrope',
                          color: textPrimary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4, left: 4),
                        child: Text(
                          _showAnnual ? '/year' : '/month',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Manrope',
                            color: textSecondary,
                          ),
                        ),
                      ),
                      if (_showAnnual) ...[
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: brandSecondary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$annualMonthlyEquiv/mo',
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Manrope',
                              color: brandSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Feature list
                  ...features.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_outline,
                              size: 16, color: brandSecondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              f,
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Manrope',
                                color: textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCtaButton(BuildContext context, SubscriptionProvider sub) {
    final tierName =
        _selectedTier == 0 ? 'Heritage Keeper' : 'Legacy Collection';
    final price = _showAnnual
        ? (_selectedTier == 0 ? '\$99.99/year' : '\$199.99/year')
        : (_selectedTier == 0 ? '\$9.99/month' : '\$19.99/month');

    return ElevatedButton(
      onPressed: sub.isLoading ? null : () => _purchase(context, sub),
      style: ElevatedButton.styleFrom(
        backgroundColor: brandPrimary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      child: sub.isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            )
          : Text(
              'Get $tierName — $price',
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }

  // ── Actions ──────────────────────────────────────────────────────────────

  Future<void> _purchase(
      BuildContext context, SubscriptionProvider sub) async {
    final offerings = sub.offerings;
    if (offerings == null) return;

    final offeringId = _selectedTier == 0
        ? 'heritage_keeper'
        : 'legacy_collection';
    final offering = offerings.getOffering(offeringId);
    if (offering == null) return;

    final package = _showAnnual
        ? offering.annual
        : offering.monthly;
    if (package == null) return;

    final success = await sub.purchase(package);
    if (success && mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Welcome to Legacy Table Premium!'),
          backgroundColor: brandSecondary,
        ),
      );
    }
  }

  Future<void> _restore(BuildContext context) async {
    final sub = context.read<SubscriptionProvider>();
    final restored = await sub.restore();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          restored
              ? 'Purchases restored successfully!'
              : 'No previous purchases found.',
        ),
        backgroundColor: restored ? brandSecondary : Colors.orange,
      ),
    );
  }
}
