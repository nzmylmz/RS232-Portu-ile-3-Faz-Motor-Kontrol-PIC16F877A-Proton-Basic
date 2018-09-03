'26 ÞUBAT 2007 PAZARTESÝ; BÝLGÝSAYAR KONTROLLÜ 3 FAZLI ELEKTRÝK MOTORU
device=16f877               'Kullanýlacak olan PIC 
ADIN_RES = 10               'Okunan analog veri sonucu 10 bit
ADIN_TAD = FRC              'RC OSC seçili
ADIN_STIME = 50             'Örnekleme süresi 50 mikrosaniye
Dim sure As Word            'sure deðiþkeni 2 baytlýk word tipi olarak ayarlandý. sebep; analog veri 10 bit
dim gelen as byte           'PIC e gönderilen seri verinin tutulacaðý deðiþken
dim manuel as portb.0       'el ile kontrolde portb nin 0 . biti seçildi
dim ileri as portc.0        'el ile ileri yön kontrolu tanýmlandý
dim geri as portc.1         'el iler geri yön kontrolü tanýmlandý
dim durbutton as portc.2    'el ile dur kontrolü tanýmlandý
trisb = %00000001           'PORTB nin tüm bitleri çýkýþ DISPLAY için 
trisc = %10000011           'PORTC nin tüm bitleri giriþ SERÝ veri alýmý
trisd = %00000000           'PORTD nin tüm bitleri çýkýþ LED ve OPTOTRIAC larý tetikler
TRISa = %00000001           'PORTA.0 analog veri giriþi olarak beilirlendi
ADCON1 = %10000000          'PORTA.0 daki ANALOG veri ayarlandý
ANAPROGRAM:                 'Programýn baþladýðýna iliþkin bir etiket tanýmladýk isteðe baðlýdýr.Yalýnlýk açýsýndan
    low portd               'PORTD nin tüm bitleri kapandý
    serout portc.6 , 16468, ["HOÞGELDÝNÝZ",13,13,"BU SÝMÜLASYON NAZIM YILMAZ TARAFINDAN HAZIRLANMISTIR.",13,13,"KOMUTLAR :",13,13,"-- 1:ÝLERÝ -- 2:GERÝ -- 3:DUR --"]
    'Seri veri olarak "" içerisindeki string ifadelerin yaný sýra ASCII 13 deðeri gönderildi.   
DONGU:                                              'dongu isimli bir etiket oluþturuldu            
while manuel=0                                      'manuel isimli anahtara akým gelmediði sürece
    serin portc.7 , 16468,[ gelen ]                 'PORTC.7 den 9600 bps hýzýnda gelen veri okundu
    if gelen=49 then GOTO ILERIYON                  'gelen verinin ASCII si 49 mu bakýldý
    if gelen=50 then GOTO GERIYON                   'gelen verinin ASCII si 50 ise koþulu    
    if gelen=51 then goto dur                       'gelen verinin ASCII si 51 ise   
wend                                                'while döngüsü sonu
if ileri=1 then goto ileriyon                       'ileri yönde kullanýlacak butona akým verilirse
if geri=1 then goto geriyon                         'geri yönde kullanýlacak butona akým verilirse
if durbutton=1 then dur                             'durbuttonu'na basýlýrsa dur etiketine git
GOTO DONGU                                          'DONGU ye geri dön
        ILERIYON:                                   'ileri yön için kullnýlacak program etiketi
                sure = adin 0                       'Analog çevirim sonucu, sure deðiþkenine aktarýldý
                print cls                           'Display in ekraný temizlendi
                print AT 1,1, "ILERI YONDE"         'Displayin 1.satýr,1.sütununa veri yazýldý
                print at 2,1, "YILDIZ DONUYOR"      'dispalin 2.satýr 1.sütununa veri yazýldý
                portd=0                             'PORTD nin tüm bitleri kapatýldý
                LOW PORTC.4                         'PORTC.0 kapatýldý
                LOW PORTC.5                         'PORTC.1 kapatýldý
                portd=%11111000                     'PORTD nin 0,1,2,3,4 ve 5. bitleri açýlýp diðerleri kapatýþdý
                delayms sure*3                      'okunan analog veri 3 ile çarpýlarak yýldýz bekleme süresi ayarlandý
                print AT 1,1, "ILERI YONDE"         '
                print at 2,1, "UCGEN DONUYOR"       '
                portd=0                             'PORTD nin tüm bitleri kapatýldý low durumu
                delayms 30                          'yýldýz-üçgen olayýnda kýsa devreyi önlemek için
                portd=%00111111                     'yýldýzdan üçgene geçildi
            repeat                                  'repeat-until sonsuz döngüsünün baþý
            durbutton=0                             '
            if durbutton=1 and manuel=1 then        '   
            goto dur                                '
            endif                                   '
            if manuel=0 then goto dongu             '
            until 1=2                               '
        GOTO DONGU                                  'ASCII si 49 sa ifadesinin sonu if gelen=49 then            
        GERIYON:                                    '
                sure = adin 0                       'analog çevirim sonucu, sure deðiþkenine aktarýldý
                print cls                           'displayin ekranýný temizler
                print AT 1,1, "GERI YONDE"          '
                PRINT AT 2,1, "YILDIZ DONUYOR"      '
                portd=0                             '
                HIGH PORTC.4                        'PORTC nin 0. bitini açar yani 1 yapar sebep;ters yönde hareket saðlamak
                HIGH PORTC.5                        'PORTC nin 1. bitini açar yani 1 yapar sebep;ters yönde hareket saðlamak
                portd=%11010000                     'PORTD nin ter yönde yýldýz çelýþmasýný saðalayan bitleri
                delayms sure*3                      'yýldýzda kalma suresi
                PRINT AT 1,1, "GERI YONDE"          '
                print at 2,1, "UCGEN DONUYOR"       '
                portd=0                             '
                portc.4=0                           '
                portc.5=0                           '
                delayms 30                          '
                portd=%00010111                     '
                portc.4=1                           '
                portc.5=1                           '
            repeat                                  '
            durbutton=0                             '
            if durbutton=1 then                     '
            goto dur                                '
            endif                                   '
            if manuel=0 then goto dongu             '
            until 1=2                               '
        GOTO DONGU                                  '
        DUR:                                        '
                durbutton=0
                sure = adin 0                               'durma iþleminin yapýlacaðý komutlarýn baþlama etiketi
                low portd                                   'PORTD nin tüm bitlerini kapat yani sýfýr (low) yap
                LOW PORTC.4                                 'PORTC.0 bitini kapat yani sýfýr (low) yap
                LOW PORTC.5                                 'PORTC.1 bitini kapat yani sýfýr (low) yap
                print cls,at 1,1, "ISLEM DURDURULDU"        'displayin ekranýný temizler ve 1.satýr 1.sütuna "" içindeki ifadeyi yazar
                print at 2,1, "SURE: ",dec sure*10," sl"    'analog veriyi 10 ile çarparak saliseyi bulduk   
        GOTO DONGU                                          'durum kontrolü içim DONGU etiketine geri dönülüyor
end'ANAPROGRAM ýn End i program burada sona erer.
