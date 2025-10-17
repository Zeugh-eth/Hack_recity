# Governança Onchain para Moedas Sociais  
Hackathon Submission

## 1. Resumo  
O projeto cria um modelo de governança onchain para moedas sociais locais. Ele permite que cidadãos e bancos comunitários decidam juntos, de forma transparente e segura, sobre as regras de suas moedas no ambiente blockchain.  
A estrutura usa **Aragon OSx** para gerenciar propostas, **Safe multisig** para segurança e **tokens soulbound** compatíveis com **ERC20Votes** para garantir o princípio de “um voto por pessoa”.  

DAO de exemplo:  
[https://app.aragon.org/dao/base-mainnet/0x2beBDfF784cd462aa58CF763E3b2CeFeD009B5d7/settings](https://app.aragon.org/dao/base-mainnet/0x2beBDfF784cd462aa58CF763E3b2CeFeD009B5d7/settings)

---

## 2. Problema  
Moedas sociais são ferramentas importantes para o desenvolvimento local, mas ainda dependem de estruturas tradicionais de decisão. Com a migração para blockchain, surge a necessidade de um sistema de governança que funcione dentro do mesmo ambiente tecnológico.  
Hoje, essas decisões acontecem de forma informal, com base em confiança e proximidade. No blockchain, as regras passam a ser automáticas e transparentes por meio de **smart contracts**, exigindo que a governança também seja digital, segura e participativa.

---

## 3. Objetivo  
Criar um exemplo funcional de **governança onchain** para uma moeda social, com dois grupos de decisão:  
1. **População Local** — cada pessoa com direito a um voto.  
2. **Banco Comunitário** — responsável por garantir o cumprimento das regras e atuar como filtro de segurança (veto).  

---

## 4. Estrutura do Sistema  
- **Plataforma:** Aragon OSx.  
- **População Local:** usa um **token soulbound** (não transferível) com interface ERC20Votes. Cada cidadão tem um voto, podendo delegar, mas não transferir.  
- **Banco Comunitário:** opera via **Safe multisig**, com permissão para vetar propostas que violem regras, leis ou prejudiquem o sistema.  
- **Gestão do Token da Moeda:** o contrato da moeda é controlado pela DAO, que define permissões e limites operacionais.  

---

## 5. Tipos de Propostas  
O sistema permite criar diferentes tipos de proposta com regras específicas, ajustando quórum e participação mínima conforme o impacto da decisão:  

1. **Governança:** altera parâmetros de votação ou delegação.  
2. **Política Monetária:** ajusta taxas, emissão e queima de tokens.  
3. **Cidadania:** inclui ou remove cidadãos do sistema.  
4. **Operações:** define parâmetros administrativos do banco comunitário.  
5. **Upgrades Técnicos:** altera contratos ou adiciona novas funções.  

Cada tipo tem limites de participação e apoio mínimo configuráveis, garantindo flexibilidade sem comprometer a segurança.

---

## 6. Processo de Votação  
1. Um cidadão cria uma proposta.  
2. A DAO faz um snapshot dos votos válidos.  
3. Os cidadãos votam dentro do prazo.  
4. Se os critérios de quórum e apoio forem atingidos, a proposta é aprovada.  
5. Um **timelock** impede execução imediata.  
6. O **Banco Comunitário** pode revisar e vetar a proposta durante esse período.  
7. Sem veto, o contrato executa a mudança automaticamente.

---

## 7. Parâmetros Padrão do MVP  
- **Criação de proposta:** mínimo de 1% dos cidadãos.  
- **Participação mínima:** 10% a 25%, conforme o tipo.  
- **Apoio mínimo:** 50% para decisões simples, 66% para monetárias ou técnicas.  
- **Timelock:** 24h para simples, 72h para críticas.  
- **Veto:** permitido apenas com justificativa pública.  

---

## 8. Segurança e Simplicidade  
- **Voto um por pessoa:** impede concentração de poder.  
- **Delegação opcional:** permite representação sem transferir poder econômico.  
- **Veto com transparência:** protege contra abusos e mantém legitimidade.  
- **Logs onchain:** todas as ações são públicas e rastreáveis.  
- **Operações básicas automáticas:** o Banco executa tarefas rotineiras sem votação, mantendo o sistema ágil.  

---

## 9. Rede e Compatibilidade  
- **Rede:** Base mainnet (baixa taxa e rápida confirmação).  
- **Contratos:** compatíveis com ERC20Votes e Aragon OSx.  
- **Carteiras:** compatíveis com qualquer wallet EVM.  
- **Futuro:** integração com credenciais verificáveis e provas ZK para garantir unicidade sem expor identidade.  

---

## 10. Entregáveis  
- DAO funcional criada na Base.  
- Token soulbound de cidadania.  
- Safe multisig do Banco Comunitário.  
- Demonstração de ajuste de taxa de transação simbólica.  

---

## 11. Próximos Passos  
- Implementar cadastro com verificação local e ZK proofs.  
- Adicionar delegação líquida com prazos e revogação.  
- Criar painéis públicos de governança e transparência.  
- Desenvolver templates reutilizáveis para outras moedas sociais.  

---

## 12. Conclusão  
O projeto mostra como moedas sociais podem migrar para blockchain sem perder sua essência comunitária.  
Com uma governança onchain simples, transparente e auditável, a comunidade mantém o controle das decisões enquanto o banco garante a segurança e o cumprimento das regras.  
Essa estrutura é aberta, replicável e pronta para ser adaptada por outras iniciativas de finanças locais.  
