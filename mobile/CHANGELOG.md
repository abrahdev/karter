## 2026.07.5+9

- **Animaciones**: todos los modales convertidos a bottom sheet con Material Motion (fade+scale, slide), animaciones unificadas con tokens M3 Easing/Durations
- **Notificaciones**: reset `odometerReminderLastNotified` al actualizar odómetro, invalidar `vehicleListProvider` al cambiar settings, nuevo `_NotificationListPage`
- **Diálogos**: `karterShowDialog` sin Dialog anidado (Material.transparency), odómetro como bottom sheet, fuel log editable como bottom sheet
- **UI**: removido displayName e ícono del Card info, espacio condicional según alias, ListTile envueltos en Material
- **Limpieza**: import no usado, RadioListTile migrado a RadioGroup, DropdownButtonFormField.value → initialValue
