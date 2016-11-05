require 'test_helper'

class LoteriasCaixaDuplasenaTest < Minitest::Test
  @@contest_name = "duplasena"
  @@resultados = LoteriasCaixa.send(@@contest_name)


  def test_that_it_has_a_version_number
    refute_nil ::LoteriasCaixa::VERSION
  end

  def test_it_includes_all_properties
    assert_includes @@resultados, :numbers
    assert_includes @@resultados, :prize
    assert_includes @@resultados, :contest_date
    assert_includes @@resultados, :contest_number
    assert_includes @@resultados, :is_last?
  end

  def test_that_numbers_are_not_blank
    refute_empty @@resultados[:numbers]
  end

  def test_prize_is_string
    assert_kind_of String, @@resultados[:prize]
  end

  def test_contest_date_is_date
    d, m, y = @@resultados[:contest_date].split '/'
    assert Date.valid_date? y.to_i, m.to_i, d.to_i
  end

  def test_contest_number_is_integer
    assert_kind_of Integer, @@resultados[:contest_number].to_i.to_i
  end

  def test_is_last_is_bool
    resultado = @@resultados[:is_last?] == true || @@resultados[:is_last?] == false
    assert resultado
  end

  def test_it_can_fetch_any_contest
    fifth_contest = LoteriasCaixa.send(@@contest_name, 5)
    refute_nil fifth_contest
    assert_kind_of Hash, fifth_contest
    refute_equal fifth_contest[:contest_number].to_i, @@resultados[:contest_number].to_i
  end

  def test_invalid_numbers_get_last_contest
    uninexistent_contest = LoteriasCaixa.send(@@contest_name,12000)
    refute_nil uninexistent_contest
    assert_kind_of Hash, uninexistent_contest
    assert_equal uninexistent_contest[:contest_number].to_i, @@resultados[:contest_number].to_i
  end

end
