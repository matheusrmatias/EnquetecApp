import 'package:enquetec/src/pages/use_terms.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../themes/main.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text('POLÍTICA DE PRIVACIDADE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: MainColors.primary,
        toolbarHeight: 60,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(padding: EdgeInsets.all(16),child: Column(
            children: [
              const Row(mainAxisAlignment: MainAxisAlignment.center,children: [Flexible(child: Text('POLÍTICA DE PRIVACIDADE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))]),
              const SizedBox(height: 4),
              const Row(children: [Flexible(child: Text('Seja bem-vindo ao Enquetec. Leia com atenção todos os termos abaixo.'))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('''Este documento, e todo o conteúdo do aplicativo é oferecido por Eduardo Pires Camargo, Gabriel da Silveira Mello e Matheus Rato Matias neste termo representado apenas por “GRUPO”, que regulamenta todos os direitos e obrigações com todos que acessam o aplicativo, denominado neste termo como “ALUNO”, resguardado todos os direitos previstos na legislação, trazem as cláusulas abaixo como requisito para acesso dele.''', textAlign: TextAlign.justify,))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('SEÇÃO 1. INFORMAÇÕES GERAIS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('''A presente Política de Privacidade contém informações sobre coleta, uso, armazenamento, tratamento e proteção dos dados pessoais dos usuários e visitantes do aplicativo Enquetec, com a finalidade de demonstrar absoluta transparência quanto ao assunto e esclarecer a todos interessados sobre os tipos de dados que são coletados, os motivos da coleta e a forma como os usuários podem gerenciar ou excluir as suas informações pessoais.
\nEsta Política de Privacidade aplica-se a todos os usuários e visitantes do aplicativo Enquetec e integra os Termos e Condições Gerais de Uso do aplicativo Enquetec.
''', textAlign: TextAlign.justify,))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('SEÇÃO 2. COMO RECOLHEMOS OS DADOS PESSOAIS DO USUÁRIO?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('''Os dados do usuário são recolhidos pelo aplicativo da seguinte forma:
\n•	Quando o usuário informa seu CPF e senha e efetua o login, o sistema acessa a plataforma SIGA e recolhe todos os dados do usuário, mantendo-os armazenados integralmente no dispositivo e uma cópia parcial em nuvem.
''',textAlign: TextAlign.justify,))],),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('SEÇÃO 3. QUAIS DADOS PESSOAIS RECOLHEMOS SOBRE O USUÁRIO?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('''Os dados pessoais do usuário recolhidos são os seguintes:
\n•	Dados de cadastro no Enquetec (Exemplo: nome completo, e-mail, ra, curso)
\n•	Todos os Dados presentes no SIGA (Exemplo: notas, disciplinas, horários, senha, cpf, professores, etc.)
''',textAlign: TextAlign.justify))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('SEÇÃO 4. PARA QUE FINALIDADE UTILIZAMOS OS DADOS PESSOAIS DO USUÁRIO?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('''Os dados pessoais do usuário e do visitante coletados e armazenados pela plataforma Enquetec tem por finalidade:
\n•	Bem-estar do usuário: aprimorar o produto e/ou serviço oferecido, facilitar, agilizar e cumprir os compromissos estabelecidos entre o usuário e a grupo, melhorar a experiência dos usuários e fornecer funcionalidades específicas a depender das características básicas do usuário.
\n•	Melhorias no ensino: compreender as necessidades de aprendizagem de cada usuário para auxiliar na educação.
''', textAlign: TextAlign.justify,))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('SEÇÃO 5. POR QUANTO TEMPO OS DADOS PESSOAIS FICAM ARMAZENADOS?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('''Os dados pessoais do usuário são armazenados pela plataforma durante o período necessário para a prestação do serviço ou o cumprimento das finalidades previstas no presente documento, conforme o disposto no inciso I do artigo 15 da Lei 13.709/18.
\nOs dados podem ser removidos ou anonimizados a pedido do usuário, excetuando os casos em que a lei oferecer outro tratamento.
\nAinda, os dados pessoais dos usuários apenas podem ser conservados após o término de seu tratamento nas seguintes hipóteses previstas no artigo 16 da referida lei:
\nI - Cumprimento de obrigação legal ou regulatória pelo controlador;
II - Estudo por órgão de pesquisa, garantida, sempre que possível, a anonimização dos dados pessoais;
III - transferência a terceiro, desde que respeitados os requisitos de tratamento de dados dispostos nesta Lei;
IV - Uso exclusivo do controlador, vedado seu acesso por terceiro, e desde que anonimizados os dados.
''', textAlign: TextAlign.justify,))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('SEÇÃO	6. SEGURANÇA DOS DADOS PESSOAIS ARMAZENADOS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('''A plataforma se compromete a aplicar as medidas técnicas e organizativas aptas a proteger os dados pessoais de acessos não autorizados e de situações de destruição, perda, alteração, comunicação ou difusão de tais dados.
\nA plataforma não se exime de responsabilidade por culpa exclusiva de terceiros, como em caso de ataque de hackers ou crackers. O site se compromete a comunicar o usuário em caso de alguma violação de segurança dos seus dados pessoais.
''', textAlign: TextAlign.justify,))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('SEÇÃO 7. CONSENTIMENTO', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))]),
              const SizedBox(height: 8),
              const Row(children: [Flexible(child: Text('''Ao utilizar os serviços e fornecer as informações pessoais na plataforma, o usuário está consentindo com a presente Política de Privacidade.
\nO usuário, ao cadastrar-se, manifesta conhecer e pode exercitar seus direitos de cancelrar seu cadastro, acessar e atualizar seus dados pessoais e garante a veracidade das informações por ele disponibilizadas.
\nO usuário tem direito de retirar o seu consentimento a qualquer tempo, para tanto deve entrar em contato através do e-mail contato@matheusrmatias.dev.br;
''', textAlign: TextAlign.justify,))]),
              const SizedBox(height: 8),
              Row(children: [Flexible(child: RichText(textAlign: TextAlign.justify,text: TextSpan(
                  children: [
                    const TextSpan(text: '''Todos os dados estão protegidos conforme a Lei Geral de Proteção de Dados, e ao realizar o cadastro junto ao aplicativo, o ALUNO concorda integrate com a coleta de dados conforme a Lei e com a ''', style: TextStyle(color: Colors.black,fontSize: 10, fontWeight: FontWeight.normal)),
                    TextSpan(text: 'Termos de Uso ', style: TextStyle(color: MainColors.orange,fontSize: 10, fontWeight: FontWeight.normal), recognizer: TapAndPanGestureRecognizer()..onTapUp = (e){
                      Navigator.push(context, PageTransition(child: const UseTerms(), type: PageTransitionType.rightToLeft));
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
