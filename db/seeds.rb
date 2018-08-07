# possibles order's states

OrderState.delete_all
AcceptedState.create(id: 1, name: 'Aceptada', description: 'La compra solicitada fue aceptada por el artista,
ahora accuerda el pago con él')
CancelledState.create(id: 2, name: 'Cancelada', description: 'La compra fue cancelada')
DeliveredState.create(id: 3, name: 'Finalizado', description: 'La compra se cerró satisfactoriamente')
InProgressState.create(id: 4, name: 'En progreso', description: 'La solicitud de compra fue enviada al artista. Espera que la acepte!')



