class SslMonitorJob < ApplicationJob
  GOOD = 'всё хорошо'
  BAD = 'всё плохо'
  SECOND_IN_DAY = 86_400

  BEFORE_NOT = 'Срок действия SSL сертификата еще не начался'
  AFTER_NOT = 'Срок действия SSL сертификата закончился'
  OK = 'OK'
  ERROR = 'ERROR'

  def perform()
    Domain.all.each do |domain|
      begin
        sockets = get_socket(domain.name, domain.port)
        sockets[:ssl_socket].connect # открываем сокет
        sertificate = get_sertificate(sockets[:ssl_socket])
        time_status = get_time_status(sertificate)
        if time_status[:days_to_start] >= 0
          puts "дней до началп #{time_status[:days_to_start]}"
          message_decorator(
            'Attention',
            BEFORE_NOT,
            domain.name
          )
          message_time_status(sertificate)
          domain.update(status: BAD, status_message: BEFORE_NOT)
        elsif time_status[:days_to_end] <= 0
          puts "дней до конца #{time_status[:days_to_end]}"
          message_decorator(
            'Attention',
            AFTER_NOT,
            domain.name
          )
          message_time_status(sertificate)
          domain.update(name: BAD, status_message: AFTER_NOT)
        else # 6. "Всё хорошо"
          message_decorator(GOOD, OK, domain.name)
          domain.update(status_message: OK)
          condition_warning_message(time_status[:days_to_end])
        end
        domain.update(error_message: '')
        sockets[:tcp_socket].close # закрываем сокет
      rescue OpenSSL::SSL::SSLError => e # 4. Ошибка SSL
        domain.update(status: BAD, error_message: e, status_message: ERROR)
        message_decorator(BAD, e, domain.name)
      rescue OpenSSL::X509::CertificateError => e
        domain.update(status: BAD, error_message: e, status_message: ERROR)
        message_decorator(BAD, e, domain.name)
      rescue SocketError => e # 5. Ошибка установки соединения, не связанная с SSL
        domain.update(status: BAD, error_message: e, status_message: ERROR)
        message_decorator(BAD, e, domain.name)
      end
    end
  end

  private

  def get_socket(domain_name, domain_port)
    tcp_client = TCPSocket.new(domain_name, domain_port)
    {ssl_socket: OpenSSL::SSL::SSLSocket.new(tcp_client), tcp_socket: tcp_client}
  end

  def get_sertificate(socket)
    OpenSSL::X509::Certificate.new(socket.peer_cert)
  end

  def get_time_status(sertificate)
    today = Time.now.utc
    to_start = (sertificate.not_before - today) / SECOND_IN_DAY
    to_end = (sertificate.not_after - today) / SECOND_IN_DAY
    { days_to_start: to_start, days_to_end: to_end }
  end

  def condition_warning_message(days_to_end)
    if days_to_end < 7 # 1. Сертификат истекает менее чем через 1 недели
      message_decorator(
        'Warning',
        'Осталось меньше 7 дней до конца срока дейсвия SSL сертификата',
        domain.name
      )
    elsif days_to_end < 14 # 2 Сертификат истекает менее чем через 2 неделю
      message_decorator(
        'Warning',
        'Осталось меньше 14 дней до конца срока дейсвия SSL сертификата',
        domain.name
      )
    end
  end

  def message_decorator(type, error, domain)
    puts "\n\n"
    puts '---------'
    puts "\n"
    puts "#{type}!"
    puts "Domain: #{domain}"
    puts "Message: #{error}"
    puts "\n"
    puts '---------'
  end

  def message_time_status(sertificate)
    puts "Начало действия сертификата: #{sertificate.not_before}"
    puts "Конец действия сертификата: #{sertificate.not_after}"
    puts '---------'
  end

end