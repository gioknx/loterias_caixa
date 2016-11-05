# loterias_caixa  -- busque dados de loterias
[![Coverage Status](https://coveralls.io/repos/github/gioknx/loterias-caixa/badge.svg?branch=master)](https://coveralls.io/github/gioknx/loterias-caixa?branch=master)
[![Build Status](https://travis-ci.org/gioknx/loterias-caixa.svg?branch=master)](https://travis-ci.org/gioknx/loterias-caixa)


Uma biblioteca para busca de dados das principais loterias da Caixa Federal.

Atualmente são suportadas as seguintes loterias:

Duplasena
Lotofácil
Lotomania
Megasena
Quina
Timemania

## Instalação

Adicione essa linha no seu Gemfile

```ruby
gem 'loterias_caixa'
```

E então execute:
    $ bundle

Ou instale você mesmo com:
    $ gem install loterias_caixa

## Uso

O uso é simples:

```ruby
>> LoteriasCaixa.megasena
=> {:numbers=>["11", "13", "25", "39", "46", "56"], :prize=>"R$ 5.000.000,00", :contest_date=>"03/11/2016", :contest_number=>"1872", :is_last?=>true}
>> LoteriasCaixa.megasena 1500
=> {:numbers=>["10", "18", "31", "43", "57", "59"], :prize=>"R$ 3.000.000,00", :contest_date=>"05/06/2013", :contest_number=>"1500", :is_last?=>false}
>> LoteriasCaixa.megasena 6000 # Número inválido. Retorna o último prémio.
=> {:numbers=>["11", "13", "25", "39", "46", "56"], :prize=>"R$ 5.000.000,00", :contest_date=>"03/11/2016", :contest_number=>"1872", :is_last?=>true}
```

## Contribuindo

1. Fork it
2. Crie seu branch de funcionalidade (`git checkout -b minha-funcionalidade`)
3. Commit suas alterações (`git commit -am 'Adicionando alguma funcionalidade'`)
4. Push para o branch (`git push origin minha-funcionalidade`)
5. Crie um novo Pull Request

## Licença

Essa gem está disponível como open-source sob os termos da [MIT License](http://opensource.org/licenses/MIT).

# loterias-caixa
