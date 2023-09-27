import 'dart:ui';

import 'package:enquetec/src/pages/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../themes/main.dart';

class UseTerms extends StatefulWidget {
  const UseTerms({super.key});

  @override
  State<UseTerms> createState() => _UseTermsState();
}

class _UseTermsState extends State<UseTerms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TERMOS DE USO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: MainColors.primary,
        toolbarHeight: 60,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(padding: EdgeInsets.all(16),child: Column(
            children: [
              const Row(mainAxisAlignment: MainAxisAlignment.center,children: [Flexible(child: Text('TERMOS E CONDIÇÕES DE USO DO ENQUETEC', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))]),
              const SizedBox(height: 4),
              const Row(children: [Flexible(child: Text('Seja bem-vindo ao Enquetec. Leia com atenção todos os termos abaixo.'))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('''Este documento, e todo o conteúdo do aplicativo é oferecido por Eduardo Pires Camargo, Gabriel da Silveira Mello e Matheus Rato Matias neste termo representado apenas por “GRUPO”, que regulamenta todos os direitos e obrigações com todos que acessam o aplicativo, denominado neste termo como “ALUNO”, resguardado todos os direitos previstos na legislação, trazem as cláusulas abaixo como requisito para acesso dele.''', textAlign: TextAlign.justify,))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('1. DA FUNÇÃO DO APLICATIVO', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('''Este aplicativo foi criado e desenvolvido com o intuito de proporcionar maior facilidade de acesso aos dados dos alunos presentes no SIGA (Sistema Integrado de Gestão Acadêmica) das Fatecs, além disso ele tem como um dos objetivos permitir os alunos avaliarem as disciplinas que estão cursando e ter um contato mais fácil e anônimo com os coordenadores com o propósito de aperfeiçoar o ensino.''', textAlign: TextAlign.justify,))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('2. DO ACEITE DOS TERMOS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('''Este documento, chamado “Termos de Uso”, aplicáveis a todos os alunos que acessarem o aplicativo, foi desenvolvido por Matheus Rato Matias.\n\nEste termo especifica e exige que todos os usuários ao acessar o aplicativo do GRUPO, leia e compreenda todas as cláusulas dele, visto que estabelece entre GRUPO e ALUNO direitos e obrigações entre ambas as partes, aceitos expressamente pelo ALUNO a permanecer acessando o aplicativo do GRUPO.\n\nAo continuar acessando o aplicativo, o ALUNO expressa que aceita e entende todas as cláusulas, assim como concorda integralmente com cada uma delas, sendo este aceite imprescindível para a permanência na mesma. Caso o ALUNO discorde de alguma cláusula ou termo deste contrato, ele deve imediatamente interromper sua navegação de todas as formas e meios.\n\nEste termo pode e irá ser atualizado periodicamente pelo GRUPO, que se resguarda no direito de alteração, sem qualquer tipo de aviso prévio e comunicação. É importante que o ALUNO confira sempre se houve movimentação e qual foi a última atualização dele no começo da página.''',textAlign: TextAlign.justify,))],),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('3. DO ACESSO AO APLICATIVO', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('''O aplicativo funciona normalmente 24(vinte e quatro) horas por dia, porém podem ocorrer pequenas interrupções de forma temporária para ajustes, manutenção, mudança de servidores, falhas técnicas ou por ordem de força maior, que podem deixar o aplicativo indisponível por tempo limitado.\n\nO GRUPO não se responsabiliza por nenhuma perda de oportunidade ou prejuízos que esta indisponibilidade temporária possa gerar aos usuários.\n\nEm caso de manutenção que exigirem um tempo maior, o GRUPO irá informar previamente aos ALUNOS da necessidade e do tempo previsto em que o site ou plataforma ficará offline.\n\nO acesso ao aplicativo só é permitido a alunos devidamente matriculados e com acesso ao SIGA, como também aos coordenadores previamente cadastrados na base de dados. \n\nOs coordenadores devem buscar o GRUPO para que seja realizado seu cadastro na plataforma.''',textAlign: TextAlign.justify))]),
              const SizedBox(height: 8),
              Row(children: [Flexible(child: RichText(textAlign: TextAlign.justify,text: TextSpan(
                children: [
                  const TextSpan(text: '''Todos os dados estão protegidos conforme a Lei Geral de Proteção de Dados, e ao realizar o cadastro junto ao aplicativo, o ALUNO concorda integralmente com a coleta de dados conforme a Lei e com a ''', style: TextStyle(color: Colors.black,fontSize: 10, fontWeight: FontWeight.normal)),
                  TextSpan(text: 'Política de Privacidade ', style: TextStyle(color: MainColors.orange,fontSize: 10, fontWeight: FontWeight.normal), recognizer: TapAndPanGestureRecognizer()..onTapUp = (e){
                    Navigator.push(context, PageTransition(child: PrivacyPolicy(), type: PageTransitionType.rightToLeft));
                  }),
                  const TextSpan(text: 'do GRUPO.', style: TextStyle(color: Colors.black,fontSize: 10, fontWeight: FontWeight.normal)),

                ]
              )))])

            ],
          ),),
        ),
      ),
    );
  }
}
