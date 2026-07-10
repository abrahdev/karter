# Edit Vehicle: Interval Management

## Changes

### 1. `mobile/lib/domain/repositories/vehicle_repository.dart`
Add `bool replaceNonCustom = false` param to `save()`.

### 2. `mobile/lib/data/repositories/vehicle_repository_impl.dart`
- Extract `_intervalToCompanion(MaintenanceInterval)` helper
- In `save()`, after upserting vehicle:
  - **`isNew`**: unchanged
  - **Editing + intervals + `replaceNonCustom == true`** (template replace):
    - Fetch existing intervals
    - Delete all where `isCustom == false`
    - Insert all new template intervals
  - **Editing + intervals + `replaceNonCustom == false`** (append/merge):
    - Fetch existing intervals
    - Build map `i18nKey → MaintenanceInterval`
    - For each new interval with i18nKey:
      - If match in existing + match is non-custom → update in-place (child wins)
      - If match in existing + match is custom → skip
      - If no match → insert
    - New intervals without i18nKey → always insert

### 3. `mobile/lib/presentation/pages/vehicle_form_page.dart`
- Remove `if (!_isEditing)` guard around "Buscar plantilla" button (line 474)
- In `_save()`:
  - If `_isEditing && _templateIntervals != null` → `repo.save(vehicle, intervals: intervals, replaceNonCustom: true)`
  - If `_isEditing && _templateIntervals == null` → `repo.save(vehicle)` (no interval changes)
- Add "Agregar intervalos por defecto" button when `_isEditing && _templateIntervals == null`:
  - On press: `repo.save(vehicle, intervals: defaultIntervalsFor(_vehicleType, id), replaceNonCustom: false)`
  - Show a snackbar "Intervalos agregados" on success
