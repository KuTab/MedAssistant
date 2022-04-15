//
//  SurveyQuestion.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 08.04.2022.
//

import Foundation

class SurveyQuestion {
    var title: String
    var leftBound: String
    var rightBound: String
    
    init(title: String, leftBound: String, rightBound: String) {
        self.title = title
        self.leftBound = leftBound
        self.rightBound = rightBound
    }
}

let surveyQuestions = [SurveyQuestion(title: "", leftBound: "Самочувствие плохое", rightBound: "Самочувствие хорошее"), SurveyQuestion(title: "", leftBound: "Чувствую себя слабым", rightBound: "Чувствую себя сильным"), SurveyQuestion(title: "", leftBound: "Пассивный", rightBound: "Активный"), SurveyQuestion(title: "", leftBound: "Малоподвижный", rightBound: "Подвижный"), SurveyQuestion(title: "", leftBound: "Грустный", rightBound: "Веселый"), SurveyQuestion(title: "", leftBound: "Плохое настроение", rightBound: "Хорошее настроение"), SurveyQuestion(title: "", leftBound: "Разбитый", rightBound: "Работоспособный"), SurveyQuestion(title: "", leftBound: "Обессиленный", rightBound: "Полный сил"), SurveyQuestion(title: "", leftBound: "Медлительный", rightBound: "Быстрый"), SurveyQuestion(title: "", leftBound: "Бездеятельный", rightBound: "Деятельный"), SurveyQuestion(title: "", leftBound: "Несчастный", rightBound: "Счастливый"), SurveyQuestion(title: "", leftBound: "Мрачный", rightBound: "Жизнерадостный"), SurveyQuestion(title: "", leftBound: "Напряженный", rightBound: "Расслабленный"), SurveyQuestion(title: "", leftBound: "Больной", rightBound: "Здоровый"), SurveyQuestion(title: "", leftBound: "Безучастный", rightBound: "Увлеченный"), SurveyQuestion(title: "", leftBound: "Равнодушный", rightBound: "Взволнованный"), SurveyQuestion(title: "", leftBound: "Унылый", rightBound: "Восторженный"), SurveyQuestion(title: "", leftBound: "Печальный", rightBound: "Радостный"), SurveyQuestion(title: "", leftBound: "Усталый", rightBound: "Отдохнувший"), SurveyQuestion(title: "", leftBound: "Изнуренный", rightBound: "Свежий"), SurveyQuestion(title: "", leftBound: "Сонливый", rightBound: "Возбужденный"), SurveyQuestion(title: "", leftBound: "Желание отдохнуть", rightBound: "Желание работать"), SurveyQuestion(title: "", leftBound: "Озабоченный", rightBound: "Спокойный"), SurveyQuestion(title: "", leftBound: "Пессимистичный", rightBound: "Оптимистичный"), SurveyQuestion(title: "", leftBound: "Утомляемый", rightBound: "Выносливый"), SurveyQuestion(title: "", leftBound: "Вялый", rightBound: "Бодрый"), SurveyQuestion(title: "", leftBound: "Соображать трудно", rightBound: "Соображать легко"), SurveyQuestion(title: "", leftBound: "Рассеянный", rightBound: "Внимательный"), SurveyQuestion(title: "", leftBound: "Разочарованный", rightBound: "Полный надежд"), SurveyQuestion(title: "", leftBound: "Недовольный", rightBound: "Довольный")]
