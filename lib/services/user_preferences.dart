import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserPreferences{

  static SharedPreferences _prefrences;
  static const _userId = "";
  static const _userType = "";
  static const _userProfileImg = "";
  static const _userName = "";
  static const _emailAddress = "";

  static Future init() async => 
    _prefrences = await SharedPreferences.getInstance();

  static Future setUserId(String userId) async => await _prefrences.setString(_userId, userId);

  static Future setUserType(String userType) async => await _prefrences.setString(_userType, userType);
  
  static Future setUserProfileImg(String userProfileImg) async => await _prefrences.setString(_userProfileImg, userProfileImg);

  static Future setUserName(String userName) async => await _prefrences.setString(_userName, userName);

  static Future setUserEmail(String emailAddress) async => await _prefrences.setString(_emailAddress, emailAddress);

  static  getUserId()  =>  _prefrences.getString(_userId);

  static  getUserType()  =>  _prefrences.getString(_userType);
  
  static  getUserProfileImg()  =>  _prefrences.getString(_userProfileImg);

  static getUserName()  =>  _prefrences.getString(_userName);

  static getUserEmailAddress()  =>  _prefrences.getString(_emailAddress);

}