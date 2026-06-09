class StatusHelper {
  static String format(String status) {
    switch (status) {
      case 'orcamento':
        return 'Orçamento';
      case 'em_andamento':
        return 'Em andamento';
      case 'esperando_pagamento':
        return 'Aguardando pagamento';
      case 'finalizado':
        return 'Finalizado';
      case 'cancelado':
        return 'Cancelado';
      case 'recusado':
        return 'Recusado';
      default:
        return status.replaceAll('_', ' ');
    }
  }
}
