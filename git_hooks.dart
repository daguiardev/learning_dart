import 'dart:io';
import 'package:git_hooks/git_hooks.dart';

void main(List<String> arguments) {
  Map<Git, UserFn> params = {
    Git.commitMsg: _commitMsg,
  };
  GitHooks.init(arguments, params);
}

Future<bool> _commitMsg() async {
  // Pega o caminho do arquivo que contém a mensagem do commit
  String path = GitHooks.arguments;
  String commitMessage = File(path).readAsStringSync().trim();

  // Regex padrão para Commits Convencionais
  // Aceita formatos como: fix: mensagem, feat(escopo): mensagem, chore!: quebra de compatibilidade
  RegExp conventionalCommitRegex = RegExp(
    r'^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(?:\(.+\))?!?:\s.+',
  );

  if (!conventionalCommitRegex.hasMatch(commitMessage)) {
    print('❌ Erro: A mensagem do commit não segue o padrão de Commits Convencionais!');
    print('Exemplos válidos:');
    print('  feat(cli): adicionado novo comando de ajuda');
    print('  fix: corrigido bug no parser de argumentos');
    print('\nSua mensagem foi: "$commitMessage"');
    return false; // Cancela o commit
  }

  return true; // Permite o commit
}