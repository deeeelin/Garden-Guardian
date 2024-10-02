import 'package:flutter/material.dart';
import 'package:flutter_app/models/goal.dart';
import 'package:flutter_app/models/goal_detail.dart';

Map<String, Goal> dummyGoals = {
  'g1': Goal(
      id: 'g1',
      title: 'Daily Sign In',
      content: 'Sign in every day to get all the badges!',
      icon: Icons.check_box,
      total: 10,
      goaldetails: dummyGoalDetails1),
  'g2': Goal(
      id: 'g2',
      title: 'Plant Amount',
      content: 'Grow plants to get all the badges!',
      icon: Icons.forest,
      total: 10,
      goaldetails: dummyGoalDetails2),
  'g3': Goal(
      id: 'g3',
      title: 'Plant Category',
      content: 'Grow different kinds of plants to get all the badges!',
      icon: Icons.nature,
      total: 10,
      goaldetails: dummyGoalDetails3),
  'g4': Goal(
      id: 'g4',
      title: 'Watering',
      content: 'Water your plants to get all the badges!',
      icon: Icons.water_drop,
      total: 10,
      goaldetails: dummyGoalDetails4),
  'g5': Goal(
      id: 'g5',
      title: 'Drink Water',
      content: 'Drink water every day to get all the badges!',
      icon: Icons.local_drink,
      total: 10,
      goaldetails: dummyGoalDetails5),
  'g6': Goal(
      id: 'g6',
      title: 'All Achievements',
      content: 'Complete all the achievements to get the badge!',
      icon: Icons.stars_rounded,
      total: 1,
      goaldetails: dummyGoalDetails6)
};

const dummyGoalDetails1 = {
  'd1': GoalDetail(
    id: 'd1',
    goal: 'g1',
    title: 'You have to sign-in 1 day!',
    total: 1,
  ),
  'd2': GoalDetail(
    id: 'd2',
    goal: 'g1',
    title: 'You have to sign-in 3 days!',
    total: 3,
  ),
  'd3': GoalDetail(
    id: 'd3',
    goal: 'g1',
    title: 'You have to sign-in 7 days!',
    total: 7,
  ),
  'd4': GoalDetail(
    id: 'd4',
    goal: 'g1',
    title: 'You have to sign-in 15 days!',
    total: 15,
  ),
  'd5': GoalDetail(
    id: 'd5',
    goal: 'g1',
    title: 'You have to sign-in 25 days!',
    total: 25,
  ),
  'd6': GoalDetail(
    id: 'd6',
    goal: 'g1',
    title: 'You have to sign-in 40 days!',
    total: 40,
  ),
  'd7': GoalDetail(
    id: 'd7',
    goal: 'g1',
    title: 'You have to sign-in 60 days!',
    total: 60,
  ),
  'd8': GoalDetail(
    id: 'd8',
    goal: 'g1',
    title: 'You have to sign-in 120 days!',
    total: 120,
  ),
  'd9': GoalDetail(
    id: 'd9',
    goal: 'g1',
    title: 'You have to sign-in 200 days!',
    total: 200,
  ),
  'd10': GoalDetail(
    id: 'd10',
    goal: 'g1',
    title: 'You have to sign-in 300 days!',
    total: 300,
  )
};

const dummyGoalDetails2 = {
  'd1': GoalDetail(
    id: 'd1',
    goal: 'g2',
    title: 'You have to grow 1 plant!',
    total: 1,
  ),
  'd2': GoalDetail(
    id: 'd2',
    goal: 'g2',
    title: 'You have to grow 3 plants!',
    total: 3,
  ),
  'd3': GoalDetail(
    id: 'd3',
    goal: 'g2',
    title: 'You have to grow 5 plants!',
    total: 5,
  ),
  'd4': GoalDetail(
    id: 'd4',
    goal: 'g2',
    title: 'You have to grow 10 plants!',
    total: 10,
  ),
  'd5': GoalDetail(
    id: 'd5',
    goal: 'g2',
    title: 'You have to grow 15 plants!',
    total: 15,
  ),
  'd6': GoalDetail(
    id: 'd6',
    goal: 'g2',
    title: 'You have to grow 25 plants!',
    total: 25,
  ),
  'd7': GoalDetail(
    id: 'd7',
    goal: 'g2',
    title: 'You have to grow 40 plants!',
    total: 40,
  ),
  'd8': GoalDetail(
    id: 'd8',
    goal: 'g2',
    title: 'You have to grow 60 plants!',
    total: 60,
  ),
  'd9': GoalDetail(
    id: 'd9',
    goal: 'g2',
    title: 'You have to grow 80 plants!',
    total: 80,
  ),
  'd10': GoalDetail(
    id: 'd10',
    goal: 'g2',
    title: 'You have to grow 100 plants!',
    total: 100,
  )
};

const dummyGoalDetails3 = {
  'd1': GoalDetail(
    id: 'd1',
    goal: 'g3',
    title: 'You have to grow 1 kind of plants!',
    total: 1,
  ),
  'd2': GoalDetail(
    id: 'd2',
    goal: 'g3',
    title: 'You have to grow 2 kinds of plants!',
    total: 2,
  ),
  'd3': GoalDetail(
    id: 'd3',
    goal: 'g3',
    title: 'You have to grow 3 kinds of plants!',
    total: 3,
  ),
  'd4': GoalDetail(
    id: 'd4',
    goal: 'g3',
    title: 'You have to grow 4 kinds of plants!',
    total: 4,
  ),
  'd5': GoalDetail(
    id: 'd5',
    goal: 'g3',
    title: 'You have to grow 5 kinds of plants!',
    total: 5,
  ),
  'd6': GoalDetail(
    id: 'd6',
    goal: 'g3',
    title: 'You have to grow 6 kinds of plants!',
    total: 6,
  ),
  'd7': GoalDetail(
    id: 'd7',
    goal: 'g3',
    title: 'You have to grow 8 kinds of plants!',
    total: 8,
  ),
  'd8': GoalDetail(
    id: 'd8',
    goal: 'g3',
    title: 'You have to grow 10 kinds of plants!',
    total: 10,
  ),
  'd9': GoalDetail(
    id: 'd9',
    goal: 'g3',
    title: 'You have to grow 12 kinds of plants!',
    total: 12,
  ),
  'd10': GoalDetail(
    id: 'd10',
    goal: 'g3',
    title: 'You have to grow 15 kinds of plants!',
    total: 15,
  )
};

const dummyGoalDetails4 = {
  'd1': GoalDetail(
    id: 'd1',
    goal: 'g4',
    title: 'You have to water your plant 1 time!',
    total: 1,
  ),
  'd2': GoalDetail(
    id: 'd2',
    goal: 'g4',
    title: 'You have to water your plant 3 times!',
    total: 3,
  ),
  'd3': GoalDetail(
    id: 'd3',
    goal: 'g4',
    title: 'You have to water your plant 7 times!',
    total: 7,
  ),
  'd4': GoalDetail(
    id: 'd4',
    goal: 'g4',
    title: 'You have to water your plant 15 times!',
    total: 15,
  ),
  'd5': GoalDetail(
    id: 'd5',
    goal: 'g4',
    title: 'You have to water your plant 25 times!',
    total: 25,
  ),
  'd6': GoalDetail(
    id: 'd6',
    goal: 'g4',
    title: 'You have to water your plant 40 times!',
    total: 40,
  ),
  'd7': GoalDetail(
    id: 'd7',
    goal: 'g4',
    title: 'You have to water your plant 60 times!',
    total: 60,
  ),
  'd8': GoalDetail(
    id: 'd8',
    goal: 'g4',
    title: 'You have to water your plant 90 times!',
    total: 90,
  ),
  'd9': GoalDetail(
    id: 'd9',
    goal: 'g4',
    title: 'You have to water your plant 140 times!',
    total: 140,
  ),
  'd10': GoalDetail(
    id: 'd10',
    goal: 'g4',
    title: 'You have to water your plant 200 times!',
    total: 200,
  )
};

const dummyGoalDetails5 = {
  'd1': GoalDetail(
    id: 'd1',
    goal: 'g5',
    title: 'You have to drink water 1 day!',
    total: 1,
  ),
  'd2': GoalDetail(
    id: 'd2',
    goal: 'g5',
    title: 'You have to drink water 3 days!',
    total: 3,
  ),
  'd3': GoalDetail(
    id: 'd3',
    goal: 'g5',
    title: 'You have to drink water 7 days!',
    total: 7,
  ),
  'd4': GoalDetail(
    id: 'd4',
    goal: 'g5',
    title: 'You have to drink water 15 days!',
    total: 15,
  ),
  'd5': GoalDetail(
    id: 'd5',
    goal: 'g5',
    title: 'You have to drink water 25 days!',
    total: 25,
  ),
  'd6': GoalDetail(
    id: 'd6',
    goal: 'g5',
    title: 'You have to drink water 40 days!',
    total: 40,
  ),
  'd7': GoalDetail(
    id: 'd7',
    goal: 'g5',
    title: 'You have to drink water 60 days!',
    total: 60,
  ),
  'd8': GoalDetail(
    id: 'd8',
    goal: 'g5',
    title: 'You have to drink water 120 days!',
    total: 120,
  ),
  'd9': GoalDetail(
    id: 'd9',
    goal: 'g5',
    title: 'You have to drink water 200 days!',
    total: 200,
  ),
  'd10': GoalDetail(
    id: 'd10',
    goal: 'g5',
    title: 'You have to drink water 300 days!',
    total: 300,
  )
};

const dummyGoalDetails6 = {
  'd1': GoalDetail(
    id: 'd1',
    goal: 'g6',
    title: 'You have to complete all the badges!',
    total: 50,
  ),
};
