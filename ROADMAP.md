## História 1 - Backend

Eu, como administrador do jogo, quero ter a estatística por jogo do total de mortes, mortes por causa e mortes causadas pelo <world>, para entender a dificuldade dos jogadores.

## Entendendo o log

Toda partida inicia com ```InitGame```, mas não há um padrão específico para o término. Pode-se encontrar ```Shutdown``` e ```Exit```, mas há casos em que nenhum aparece, como na partida número dois. Por isso, validei o início de um novo jogo para determinar corretamente o final de cada partida.

Depois, analisei como as mortes acontecem. A linha ```Kill``` contém três IDs: killer (assassino), victim (vítima) e mod (modo de morte)

Também gravei o tempo da partida, mas acabei não usando no final. Além disso, optei por não armazenar os nomes dos jogadores, pois não eram necessários para a tarefa. Em vez disso, salvei-os com um nome genérico seguido pelo ID do log.

## Modelos e importação
Criei os modelos ```Games```, ```kills```, ```Players``` e ```DeathCauses```

Implementei a importação dos dados na classe ```LogImporter```.


## Interface
Criei a controller ```Games``` e a view ```index``` para exibir as estatísticas por partida.

Na tabela, apresento as estatísticas gerais de cada partida.

No header da página, há um accordion que expande para exibir as estatísticas gerais, somando todas as partidas.

## O que adicionaria

Ajustaria a visualização da tabela para exibir os totais por mod, pois atualmente os dados foram apenas jogados na coluna.

Se tivesse mais tempo, talvez criasse um dashboard com gráficos para tornar a visualização mais agradável. Também incluiria estatísticas por jogador e salvaria os nomes dos jogadores.
