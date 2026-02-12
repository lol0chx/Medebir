String checkPhoneNumber(String phoneNumber) {
  if (phoneNumber.substring(0, 4) == "+251" && phoneNumber.length == 13) {
    return phoneNumber;
  } else if (phoneNumber.substring(0, 1) == "0" && phoneNumber.length == 10) {
    return "+251" + phoneNumber.substring(1);
  } else if (phoneNumber.substring(0, 1) == "9" && phoneNumber.length == 9) {
    return "+251" + phoneNumber;
  } else {
    return "error";
  }
}
