import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendion/config/app_constants.dart';
import 'package:vendion/l10n/app_localizations.dart';
import 'package:vendion/models/brands.dart';
import 'package:vendion/models/models.dart';
import 'package:vendion/providers/vehicles_provider.dart';

import '../widgets/customRangeSelector.dart';
import '../widgets/textBox_widget.dart';

class FiltersScreen extends StatefulWidget {
  static String routeName = "/filtersScreen";

  const FiltersScreen({Key? key}) : super(key: key);

  @override
  State<FiltersScreen> createState() => _StateFilterScreen();
}

class _StateFilterScreen extends State<FiltersScreen> {
  final TextEditingController _locationController = TextEditingController();

  int _conditions = 0;
  bool _loadingBrands = true;
  bool _loadingModels = false;
  List<Brand> _brands = [];
  List<Model> _models = [];
  Brand? _selectedBrand;
  Model? _selectedModel;

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _loadBrands() async {
    setState(() {
      _loadingBrands = true;
    });

    try {
      final vehicleProvider =
          Provider.of<VehiclesProvider>(context, listen: false);
      final response = await vehicleProvider.getBrands();
      if (!mounted) {
        return;
      }
      setState(() {
        _brands = response;
        _loadingBrands = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _brands = [];
        _loadingBrands = false;
      });
    }
  }

  Future<void> _loadModelsForBrand(Brand? brand) async {
    setState(() {
      _selectedBrand = brand;
      _selectedModel = null;
      _models = [];
      _loadingModels = brand?.id != null;
    });

    if (brand?.id == null) {
      return;
    }

    try {
      final vehicleProvider =
          Provider.of<VehiclesProvider>(context, listen: false);
      final response = await vehicleProvider.getModels(brand!.id!);
      if (!mounted) {
        return;
      }
      setState(() {
        _models = response;
        _loadingModels = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _models = [];
        _loadingModels = false;
      });
    }
  }

  void _setCondition(int condition) {
    if (_conditions == condition) {
      return;
    }

    setState(() {
      _conditions = condition;
      _selectedModel = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(context.l10n.t('filters')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 34),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarConditions(),
            const SizedBox(height: AppSpacing.lg),
            _buildBrandModelSelectors(),
            _buildLocationField(),
            _buildPriceRange(),
            _buildApplyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCarConditions() {
    final options = [
      _FilterCondition(0, context.l10n.t('all')),
      _FilterCondition(1, context.l10n.t('new')),
      _FilterCondition(2, context.l10n.t('used')),
    ];

    return Row(
      children: options.map((option) {
        final selected = _conditions == option.value;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              selected: selected,
              label: Center(child: Text(option.label)),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: selected
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
              onSelected: (_) => _setCondition(option.value),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBrandModelSelectors() {
    final fillColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff1d1d24)
        : AppColors.lightSurface;

    return Column(
      children: [
        if (_loadingBrands)
          const LinearProgressIndicator(color: AppColors.primary),
        DropdownButtonFormField<Brand>(
          value: _selectedBrand,
          isExpanded: true,
          decoration: _pickerDecoration(context.l10n.t('brand'), fillColor),
          items: _brands
              .map(
                (brand) => DropdownMenuItem<Brand>(
                  value: brand,
                  child: Text(brand.name ?? context.l10n.t('noData')),
                ),
              )
              .toList(),
          onChanged: _loadingBrands ? null : _loadModelsForBrand,
        ),
        const SizedBox(height: AppSpacing.md),
        if (_loadingModels)
          const LinearProgressIndicator(color: AppColors.primary),
        DropdownButtonFormField<Model>(
          value: _selectedModel,
          isExpanded: true,
          decoration: _pickerDecoration(
            _selectedBrand == null
                ? context.l10n.t('selectBrandFirst')
                : context.l10n.t('model'),
            fillColor,
          ),
          items: _models
              .map(
                (model) => DropdownMenuItem<Model>(
                  value: model,
                  child: Text(model.modelName ?? context.l10n.t('noData')),
                ),
              )
              .toList(),
          onChanged: _selectedBrand == null || _loadingModels
              ? null
              : (model) {
                  setState(() {
                    _selectedModel = model;
                  });
                },
        ),
      ],
    );
  }

  InputDecoration _pickerDecoration(String label, Color fillColor) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Widget _buildLocationField() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: CustomTextBox(
        controller: _locationController,
        onChange: () {},
        text: context.l10n.t('location'),
        svg: const Icon(
          Icons.location_on_rounded,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildPriceRange() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.t('priceRange'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          CustomRangeSelect(
            min: 0,
            max: 60000,
            onChange: (RangeValues valores) {
              if (kDebugMode) {
                print(valores);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          onPressed: () {},
          child: Text(
            context.l10n.t('applyFilters'),
            style: const TextStyle(
              fontSize: 15,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterCondition {
  const _FilterCondition(this.value, this.label);

  final int value;
  final String label;
}
