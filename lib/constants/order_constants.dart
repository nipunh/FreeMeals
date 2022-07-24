class OrderDecrypt {
  static Map<int, String> paymentStaus = {
    0: 'Payment in progress',
    1: 'Payment made',
    2: 'Payment failed',
    3: 'Payment refund',
    10: 'Payment Mismatch',
  };

  static Map<int, String> orderStaus = {
    0: 'Awaiting',
    1: 'Server Assigned',
    2: 'Ongoing',
    3: 'Ready',
    4: 'Served',
    5: 'Delivered',
    6: 'Cancelled',
    7: 'Not Picked Up',
    8: 'Payment Failed',
    9: 'Payment Success'
  };

  static Map<int, String> cancelledBy = {
    1: 'User',
    2: 'Vendor',
    3: 'Admin',
    4: 'Others',
  };

  static Map<int, String> paidTo = {
    1: 'Client app',
    2: 'Counter app',
    3: 'Cafeteria pos',
    4: 'Others'
  };

  static Map<int, String> conflictState = {
    0: 'No Conflict',
    1: 'User Posted',
    11: 'Vendor Responded/ Admin yet to Respond - Not Vendor Fault',
    12: 'Vendor Responded/ Admin yet to Respond - Vendor Fault',
    21: 'Admin Responded - Not Vendor Fault',
    22: 'Admin Responded - Vendor Fault',
    31: 'V/A agree - Not Vendor Fault',
    32: 'V/A agree - Vendor Fault',
    40: 'Error',
  };

  static Map<String, String> feedbackReasons = {
    // need an empty string
    '': '',
    'UF01': 'Taste',
    'UF02': 'Quality',
    'UF03': 'Service',
    'UF04': '',
    'UF10': 'Others',
    'VF01': 'Not Vendor fault',
    'VF02': 'Vendor fault',
    'VF10': 'Other Feedback',
    'AF01': 'Not Vendor fault',
    'AF02': 'Vendor fault',
    'AF10': 'Other Feedback',
    'UC01': 'Item unavailable/Counter closed',
    'UC02': 'Wait time too long',
    'UC03': 'Ordered by mistake',
    'UC10': 'Others',
    'VC01': 'Client didn\'t pick up',
    'VC02': 'Item unavailable',
    'VC03': 'Counter closed',
    'VC10': 'Others',
    'AC01': '',
    'AC02': '',
    'AC03': '',
    'AC04': '',
    'AC10': '',
  };

  static Map<int, String> cookingStatus = {
    0: 'Requested',
    1: 'Cooking',
    2: 'Served',
    3: 'Rejected'
  };
}
