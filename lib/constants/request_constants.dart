class RequestDecrypt {
  static Map<int, String> paymentStaus = {
    0: 'Waiting',
    1: 'Confirmed',
    2: 'Declined by manager',
    3: 'Cancelled by user'
  };

  static Map<int, String> tableBookingStatus = {
    0 : 'Awaiting Confirmation',
    1 : 'Bookign Confirmed',
    2 : 'Rejected by Restaurant',
    3 : 'Cancelled by User',
    4 : 'Completed'
  };
}