import 'dart:async';
import 'package:enquetec/src/models/assessment.dart';
import 'package:enquetec/src/models/schedule.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/student.dart';

class StudentAccount{
  WebViewController view = WebViewController();
  WebViewCookieManager cookie = WebViewCookieManager();
  bool _isLoad = false;

  StudentAccount(){
   debugPrint('Contructor');
   _initialize();
  }

  Future<void> _initialize() async{
    debugPrint('initialize');
    await view.setJavaScriptMode(JavaScriptMode.unrestricted);
    await view.loadRequest(Uri.parse('https://siga.cps.sp.gov.br/aluno/login.aspx'));
    await view.setNavigationDelegate(NavigationDelegate(
      onWebResourceError: (e)=>throw Exception('WEB failed'),
      onPageFinished: (e){
            _isLoad = true;
          },
    ));
  }

  Future<void> userLogin(Student student)async{
    int i=0;
    for(i; i<10; i++){
      await Future.delayed(const Duration(milliseconds: 1000),()async{
        if(await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/home.aspx' && _isLoad){
          debugPrint('home loaded');
          await view.runJavaScriptReturningResult("document.getElementById('span_vUNI_UNIDADENOME_MPAGE').textContent").then((value) => student.fatec=value.toString().replaceAll('"', ''));
          await view.runJavaScriptReturningResult("document.getElementById('span_vACD_CURSONOME_MPAGE').textContent").then((value) => student.graduation=value.toString().replaceAll('"', ''));
          await view.runJavaScriptReturningResult("document.getElementById('span_vSITUACAO_MPAGE').textContent").then((value) => student.progress=value.toString().replaceAll('"', ''));
          await view.runJavaScriptReturningResult("document.getElementById('span_vACD_PERIODODESCRICAO_MPAGE').textContent").then((value) => student.period=value.toString().replaceAll('"', ''));
          await view.runJavaScriptReturningResult("document.getElementById('span_MPW0041vPRO_PESSOALNOME').textContent").then((value) => student.name=value.toString().replaceAll('"', '').replaceAll('-', ''));
          await view.runJavaScriptReturningResult("document.getElementById('span_MPW0041vACD_ALUNOCURSOREGISTROACADEMICOCURSO').textContent").then((value) => student.ra=value.toString().replaceAll('"', ''));
          await view.runJavaScriptReturningResult("document.getElementById('span_MPW0041vACD_ALUNOCURSOCICLOATUAL').textContent").then((value) => student.cycle=value.toString().replaceAll('"', ''));
          await view.runJavaScriptReturningResult("document.getElementById('span_MPW0041vACD_ALUNOCURSOINDICEPP').textContent").then((value) => student.pp=value.toString().replaceAll('"', ''));
          await view.runJavaScriptReturningResult("document.getElementById('span_MPW0041vACD_ALUNOCURSOINDICEPR').textContent").then((value) => student.pr=value.toString().replaceAll('"', ''));
          await view.runJavaScriptReturningResult("document.getElementById('span_MPW0041vINSTITUCIONALFATEC').textContent").then((value) => student.email=value.toString().replaceAll('"', ''));
          await view.runJavaScriptReturningResult("document.getElementById('MPW0041FOTO').firstChild.src").then((value) => student.imageUrl=value.toString().replaceAll('"', ''));
          _isLoad = false;
          i=11;
          debugPrint('user basic data coleted');
        }else if(_isLoad && await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/login.aspx'){
          debugPrint('login loaded');
          _isLoad = false;
          await view.runJavaScript("document.getElementById('vSIS_USUARIOID').value='${student.cpf}'");
          await view.runJavaScript("document.getElementById('vSIS_USUARIOSENHA').value='${student.password}'");
          await view.runJavaScript("document.getElementsByName('BTCONFIRMA')[0].click()");
        }

      });
    }
    if(i==10){
      String error = '';
      await view.runJavaScriptReturningResult("document.getElementById('span_vSAIDA').textContent").then((value){
        error = value.toString();
      });
      if(error=='"Não confere Login e Senha"'){
        throw Exception('User or Password Incorrect');
      }else{
        throw Exception('User not loaded');
      }
    }
  }

  Future<void> userHistoric(Student student) async{
    int k = 0;
    if(await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/home.aspx'){
      await view.runJavaScript("document.getElementById('ygtvlabelel8Span').click()");
      for(k;k<10;k++){
        await Future.delayed(const Duration(milliseconds: 1000),()async{
          if(_isLoad){
            debugPrint('historic loaded');
            List<Map<String,String>> historic = [];
            await view.runJavaScriptReturningResult("document.getElementById('Grid1ContainerTbl').getElementsByTagName('tbody')[0].getElementsByTagName('tr').length").then((value)async{
              for(int i=1; i<int.parse(value.toString()); i++){
                await view.runJavaScriptReturningResult("document.getElementById('Grid1ContainerTbl').getElementsByTagName('tbody')[0].getElementsByTagName('tr')[$i].getElementsByTagName('span').length").then((value)async{
                  Map<String, String> discipline = {};
                  for(int j=0; j<int.parse(value.toString());j++){
                    await view.runJavaScriptReturningResult("document.getElementById('Grid1ContainerTbl').getElementsByTagName('tbody')[0].getElementsByTagName('tr')[$i].getElementsByTagName('span')[$j].textContent").then((value){
                      if(j==0){
                        discipline['acronym'] = value.toString().replaceAll('"', '');
                      }else if(j==1){
                        discipline['name'] = value.toString().replaceAll('"', '');
                      }else if(j==2){
                        discipline['period'] = value.toString().replaceAll('"', '');
                      }else if(j==3){
                        discipline['average'] = value.toString().replaceAll('"', '');
                      }else if(j==4){
                        discipline['frequency'] = value.toString().replaceAll('"', '');
                      }else if(j==5){
                        discipline['absence'] = value.toString().replaceAll('"', '');
                      }else if(j==6){
                        discipline['observation'] = value.toString().replaceAll('"', '');
                      }
                    });
                  }
                  historic.add(discipline);
                });
              }

            });
            k=11;
            _isLoad = false;
            historic.sort((a, b) {
              int periodComparison = a["period"]!.compareTo(b["period"]!);
              if (periodComparison != 0) {
                return periodComparison;
              } else {
                return a["name"]!.compareTo(b["name"]!);
              }
            });
            student.historic = historic;
          }
        });
      }
      if(k==10){
        throw Exception('Historic User Data not loaded');
      }
    }else{
      throw Exception('User not loaded');
    }
  }

  Future<void> userAssessment(Student student) async{
    int i = 0;
    if(await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/home.aspx' || await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/historicocompleto.aspx'){
      await view.runJavaScript("document.getElementById('ygtvlabelel10Span').click()");
      for(i; i<10; i++){
        await Future.delayed(const Duration(milliseconds: 1000),()async{
          if(_isLoad){
            debugPrint('assessments loaded');
            List<DisciplineAssessment> assessments = [];
            await view.runJavaScriptReturningResult("document.getElementById('Grid4ContainerTbl').firstChild.children.length/3").then((value)async{
              for(int j=0; j<int.parse(value.toString()); j++){
                DisciplineAssessment discipline = DisciplineAssessment();
                String prefix = '00';
                if(j>=9){
                  prefix+=(j+1).toString();
                }else{
                  prefix+='0${j+1}';
                }
                await view.runJavaScriptReturningResult("document.getElementById('TABLE2_$prefix').firstChild.children[0].children[0].firstChild.textContent").then((value) => discipline.acronym = value.toString().replaceAll('"', ''));
                await view.runJavaScriptReturningResult("document.getElementById('TABLE2_$prefix').firstChild.children[0].children[1].textContent").then((value) => discipline.name = value.toString().replaceAll('"', ''));

                await view.runJavaScriptReturningResult("document.getElementById('TABLE2_$prefix').firstChild.children[1].children[1].textContent").then((value) => discipline.average = value.toString().replaceAll('"', ''));
                // await view.runJavaScriptReturningResult("document.getElementById('TABLE2_$prefix').firstChild.children[2].children[1].textContent").then((value) => discipline.absence = value.toString().replaceAll('"', ''));
                await view.runJavaScriptReturningResult("document.getElementById('TABLE2_$prefix').firstChild.children[3].children[1].textContent").then((value) => discipline.frequency = value.toString().replaceAll('"', ''));

                await view.runJavaScriptReturningResult("document.getElementById('Grid1Container_${prefix}Tbl').firstChild.children.length").then((grid)async{
                  if(int.parse(grid.toString())>1){
                    for(int k=1; k<int.parse(grid.toString()); k++){
                      await view.runJavaScriptReturningResult("document.getElementById('Grid1Container_${prefix}Tbl').firstChild.children[$k].children[0].textContent").then((key)async{
                        await view.runJavaScriptReturningResult("document.getElementById('Grid1Container_${prefix}Tbl').firstChild.children[$k].children[2].textContent").then((val){discipline.assessment[key.toString().replaceAll('"', '')]=val.toString().replaceAll('"', '');});
                      });
                    }
                  }
                });
                assessments.add(discipline);
              }
            });
            i=11;
            _isLoad=false;
            assessments.sort((a, b){
              if(a.name.contains('Estágio') || a.name.contains('Trabalho de Graduação')){
                return 1;
              }else if(b.name.contains('Estágio') || b.name.contains('Trabalho de Graduação')){
                return -1;
              }else{
                return a.name.compareTo(b.name);
              }
            });
            student.assessment = assessments;
          }
        });
      }
      if(i==10){
        throw Exception('Assessment User Data not loaded');
      }
    }else{
      throw Exception('User not loaded');
    }
  }

  Future<void> userSchedule(Student student)async{
    int i = 0;
    if(await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/home.aspx' || await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/notasparciais.aspx'){
      await view.runJavaScript("document.getElementById('ygtvlabelel9Span').click()");
      for(i; i<10; i++){
        await Future.delayed(const Duration(milliseconds: 1000),()async{
          if(_isLoad) {
            debugPrint('schedule loaded');
            List<Schedule> schedule = [];
            Map<String, String> acronyms = {};
            await view.runJavaScriptReturningResult(
                "document.getElementById('Grid1ContainerTbl').firstChild.children.length")
                .then((value) async {
              for (int j = 1; j < int.parse(value.toString()); j++) {
                await view.runJavaScriptReturningResult("document.getElementById('Grid1ContainerTbl').firstChild.children[$j].children[0].textContent").then((disciplineAcronym)async{
                  await view.runJavaScriptReturningResult("document.getElementById('Grid1ContainerTbl').firstChild.children[$j].children[1].textContent").then((disciplineName)async{
                    acronyms[disciplineAcronym.toString()]=disciplineName.toString().replaceAll('"', '').substring(0,disciplineName.toString().indexOf('-')-1);
                    for(int k = 0; k<student.assessment.length;k++){
                      if(student.assessment[k].name.replaceAll('"', '') == disciplineName.toString().replaceAll('"', '').substring(0, disciplineName.toString().indexOf('-')-2)){
                        await view.runJavaScriptReturningResult("document.getElementById('Grid1ContainerTbl').firstChild.children[$j].children[3].textContent").then((disciplineTeacher)async{
                          student.assessment[k].teacher=disciplineTeacher.toString().replaceAll('"', '');
                        });
                      }
                    }
                  });
                });
              }
            });
            for(int j = 2; j<7; j++){
              Schedule scheduleTemp = Schedule();
              await view.runJavaScriptReturningResult("document.getElementById('TEXTBLOCK${j+3}').textContent").then((value){
                scheduleTemp.weekDay = value.toString().replaceAll('"', '');
              });
              await view.runJavaScriptReturningResult("document.getElementById('Grid${j}ContainerTbl').firstChild.children.length").then((value)async{
                for (int k = 1; k < int.parse(value.toString()); k++) {
                  await view.runJavaScriptReturningResult("document.getElementById('Grid${j}ContainerTbl').firstChild.children[$k].children[1].textContent").then((time)async{
                    await view.runJavaScriptReturningResult("document.getElementById('Grid${j}ContainerTbl').firstChild.children[$k].children[2].textContent").then((discipline){
                      scheduleTemp.schedule.add([time.toString().replaceAll('"', ''),acronyms[discipline].toString()]);
                    });
                  });
                }
              });
              scheduleTemp.schedule.sort((a,b)=>a[0].compareTo(b[0]));
              schedule.add(scheduleTemp);
            }
            i=11;
            _isLoad=false;
            student.schedule=schedule;
          }
        });
      }
    }
  }

  Future<void> userAbsences(Student student)async{
    if(await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/home.aspx' || await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/horario.aspx'){
      await view.runJavaScript("document.getElementById('ygtvlabelel11Span').click()");
      for(int i = 0; i<10; i++){
        await Future.delayed(const Duration(milliseconds: 1000),()async{
          if(_isLoad) {
            debugPrint('absences loaded');
            for(int j = 0; j<student.assessment.length; j++){
              String prefix = '00';
              if(j>=9){
                prefix+=(j+1).toString();
              }else{
                prefix+='0${j+1}';
              }
              await view.runJavaScriptReturningResult("document.getElementById('span_vACD_DISCIPLINASIGLA_$prefix').textContent").then((acronym) async {
                for (var element in student.assessment) {
                  if(element.acronym == acronym.toString().replaceAll('"', '')){
                    await view.runJavaScriptReturningResult("document.getElementById('span_vAUSENCIAS_$prefix').textContent").then((value) async {
                      student.assessment[student.assessment.indexWhere((disc) => disc == element)].absence = value.toString().replaceAll('"', '');
                    });
                  }
                }
              });
            }
            i=11;
            _isLoad=false;
          }
        });
      }
    }
  }


  Future<void> userAssessmentDetails(Student student) async{

    for(int i = 0; i<student.assessment.length; i++){
      await view.loadRequest(Uri.parse("https://siga.cps.sp.gov.br/aluno/planoensino.aspx?${student.assessment[i].acronym}", 0, 56));

      int j = 0;
      for(j; j<10; j++){
        await Future.delayed(const Duration(milliseconds: 1000), ()async{
          if(_isLoad){
            await view.runJavaScriptReturningResult('document.getElementById("span_W0008W0013vACD_DISCIPLINAAULASTOTAISPERIODO").textContent').then((value){
              student.assessment[i].maxAbsences = (int.parse(value.toString().replaceAll('"', "").replaceAll(" ", ""))~/4).toString();
              student.assessment[i].totalClasses = value.toString().replaceAll('"', "").replaceAll(" ", "");
            });
            await view.runJavaScriptReturningResult('document.getElementById("span_W0008W0013vACD_DISCIPLINAEMENTA").textContent').then((value){
              student.assessment[i].syllabus = value.toString().replaceAll('"', '');
            });
            await view.runJavaScriptReturningResult('document.getElementById("span_W0008W0013vACD_DISCIPLINAOBJETIVO").textContent').then((value){
              student.assessment[i].objective = value.toString().replaceAll('"', '');
            });
            _isLoad = false;
            j = 10;
          }
        });
      }

      if(j==10){
        throw Exception("User not loaded");
      }
    }
  }
}