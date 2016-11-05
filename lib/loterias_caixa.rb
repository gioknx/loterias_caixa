require "loterias_caixa/version"
require 'rest-client'
require 'nokogiri'
require 'open-uri'
require 'json'

require_relative 'exceptions'


module LoteriasCaixa
  extend self

  attr_writer :logger

  def logger
    @logger ||= Logger.new($stdout).tap do |log|
      log.progname = self.name
    end
  end


  def duplasena contest_id = 0
    result = _contest("duplasena", contest_id, {})
  end

  def lotomania contest_id = 0
    _before_contest("lotomania", contest_id, {:numbers => ".simple-table > tr > td"})
  end
  def quina contest_id = 0
    _before_contest("quina", contest_id, {})
  end

  def megasena contest_id = 0
    _before_contest("megasena", contest_id, {})
  end

  def timemania contest_id = 0
    _before_contest("timemania", contest_id, {})
  end

  def lotofacil contest_id = 0
    _before_contest("lotofacil", contest_id, {:numbers => ".simple-table > tbody > tr > td"})

  end

  def _before_contest(contest_name, contest_id, css)
    result = ""
    while !result.is_a?(Hash)
      result = _contest(contest_name, contest_id, css)
    end
    result
  end

  def _contest(contest_name, contest_id, css)
    begin
      last_contest_url = _URL[contest_name.to_sym]
      post_url = _post_urls[contest_name.to_sym]
      css = _set_css(css)
      url = _get_url_or_last(contest_id, last_contest_url, post_url)

      parsed_html = _get_parsed_html(url, contest_id)

      contest_info = parsed_html.css(css[:contest_info]).text
      contest_number = contest_info.split(" ")[2]

      # Check if found contest is the one we're looking for
      raise ContestNotFound if (contest_number.to_i != contest_id and _valid_contest_id(contest_id))

      contest_date = /\((.*)\)/.match(contest_info)[1]
      resultado = parsed_html.css(css[:resultado])
      numbers = _numbers_to_hash(resultado.css(css[:numbers]))
      prize = resultado.css(css[:prize]).text
      return {numbers: numbers, prize: prize, contest_date: contest_date, contest_number: contest_number, is_last?: url == last_contest_url}

    rescue ContestNotFound => e
      return _contest(contest_name, 0, css)
    rescue Exception => e
      #logger.error(e.backtrace.join("\n"))
      return nil
      #if(e.message == "302 Found")
    end
  end

  def _URL
    base_url = "http://loterias.caixa.gov.br/wps/portal/loterias/landing/"

    {
      megasena: base_url + "megasena",
      lotofacil: base_url + "lotofacil",
      quina: base_url + "quina",
      lotomania: base_url + "lotomania",
      timemania: base_url + "timemania",
      duplasena: base_url + "duplasena",
      federal: base_url + "federal"
    }
  end

  def _post_urls
    {
      megasena: "http://loterias.caixa.gov.br/wps/portal/loterias/landing/megasena/!ut/p/a1/jY7JDoIwFEW_xS_oZbCtSxTTMhhIjAPdEILGNJEhIPj7FuPGhcN7q3dz7sshihyJqotRX4qbburiOt2K5tSKISEQIrA5PHed2vtw74A7BsgMsBKedFkMwOU2An8pfbbYAAH9r48P4-FX_0DUOyLS1Rxe4i8XcMxi_gK-KT6BLw6ZkWS5FBG3uECUUGksdsyKBAsBZpPt9OOku3NZNCRru_Oom6GfwrKpy6HrTWpx6pC22h2h06ri99kDJI8lpA!!/dl5/d5/L2dBISEvZ0FBIS9nQSEh/pw/Z7_HGK818G0KO6H80AU71KG7J0072/act/id=0/337609965170/=",
      lotofacil:"http://loterias.caixa.gov.br/wps/portal/loterias/landing/lotofacil/!ut/p/a1/04_Sj9CPykssy0xPLMnMz0vMAfGjzOLNDH0MPAzcDbz8vTxNDRy9_Y2NQ13CDA0sTIEKIoEKnN0dPUzMfQwMDEwsjAw8XZw8XMwtfQ0MPM2I02-AAzgaENIfrh-FqsQ9wBmoxN_FydLAGAgNTKEK8DkRrACPGwpyQyMMMj0VAcySpRM!/dl5/d5/L2dBISEvZ0FBIS9nQSEh/pw/Z7_61L0H0G0J0VSC0AC4GLFAD2003/act/id=0/337610675786/=/",
      quina: "http://loterias.caixa.gov.br/wps/portal/loterias/landing/quina/!ut/p/a1/jc69DoIwAATgZ_EJepS2wFgoaUswsojYxXQyTfgbjM9vNS4Oordd8l1yxJGBuNnfw9XfwjL78dmduIikhYFGA0tzSFZ3tG_6FCmP4BxBpaVhWQuA5RRWlUZlxR6w4r89vkTi1_5E3CfRXcUhD6osEAHA32Dr4gtsfFin44Bgdw9WWSwj/dl5/d5/L2dBISEvZ0FBIS9nQSEh/pw/Z7_61L0H0G0J0VSC0AC4GLFAD20G6/act/id=0/338136594327/=/",
      lotomania: "http://loterias.caixa.gov.br/wps/portal/loterias/landing/lotomania/!ut/p/a1/jY5JDoJAEEXP4gn6Y8u0bCBhNBAVhN4YgsR0ImAQh-PbGBe6EK1a1c-rqkc4yQlvy6s4lIPo2vI4zlzbaUoEDy6COPBVsDCmNHUyBTGVQCEB22XeQo8ALIw5fMfyHN1cAr723z6-FMOv_S3hn4ib2BKJHcsElQ31BUwpPoEJh0JK6m8vgoxJi2ilbmgIZCDr8cZe9HVVdqRo6_swBlXXVpf-LBOdnJo0h0iaxrjNHqVe5E0!/dl5/d5/L2dBISEvZ0FBIS9nQSEh/pw/Z7_61L0H0G0JGJVA0AKLR5T3K00V0/act/id=0/338598582570/=/",
      timemania: "http://loterias.caixa.gov.br/wps/portal/loterias/landing/timemania/!ut/p/a1/04_Sj9CPykssy0xPLMnMz0vMAfGjzOLNDH0MPAzcDbz8vTxNDRy9_Y2NQ13CDA1MzIEKIoEKnN0dPUzMfQwMDEwsjAw8XZw8XMwtfQ0MPM2I02-AAzgaENIfrh-FqsQ9wBmoxN_FydLAGAgNTKEK8DkRrACPGwpyQyMMMj0VASrq9qk!/dl5/d5/L2dBISEvZ0FBIS9nQSEh/pw/Z7_61L0H0G0JGJVA0AKLR5T3K00M4/act/id=0/338600022875/=/",
      duplasena: "http://loterias.caixa.gov.br/wps/portal/loterias/landing/duplasena/!ut/p/a1/04_Sj9CPykssy0xPLMnMz0vMAfGjzOLNDH0MPAzcDbwMPI0sDBxNXAOMwrzCjA2cDIAKIoEKnN0dPUzMfQwMDEwsjAw8XZw8XMwtfQ0MPM2I02-AAzgaENIfrh-FqsQ9wNnUwNHfxcnSwBgIDUyhCvA5EawAjxsKckMjDDI9FQGgnyPS/dl5/d5/L2dBISEvZ0FBIS9nQSEh/pw/Z7_61L0H0G0J0I280A4EP2VJV30N4/act/id=0/338600902855/=/"
    }
  end
  def _default_css
    {
      resultado: ".resultado-loteria",
      contest_info: ".title-bar > h2",
      numbers: ".numbers > li",
      prize: ".next-prize > .value"
    }
  end

  def _valid_contest_id contest_id
    return [0, '0', nil].include?(contest_id) ? false : true
  end

  def _numbers_to_hash element
    hash = []
    element.each do |e|
      hash << e.text
    end
    hash
  end

  def _set_css css
    css[:resultado] = css[:resultado] || _default_css[:resultado]
    css[:contest_info] = css[:contest_info] || _default_css[:contest_info]
    css[:numbers] = css[:numbers] || _default_css[:numbers]
    css[:prize] = css[:prize] || _default_css[:prize]

    css
  end

  def _get_url_or_last(contest_id, url_1, url_2)
    return ([0, '0', nil].include?(contest_id)) ? url_1 : url_2
  end

  def _get_parsed_html url, contest_id
    begin
      response = RestClient.post(url, {concurso: contest_id},:content_type => 'application/json')
    rescue => e
      response = e.response.follow_redirection
    end
    Nokogiri::HTML(response.body)
  end
end
