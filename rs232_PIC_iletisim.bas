'26 �UBAT 2007 PAZARTES�; B�LG�SAYAR KONTROLL� 3 FAZLI ELEKTR�K MOTORU
device=16f877               'Kullan�lacak olan PIC 
ADIN_RES = 10               'Okunan analog veri sonucu 10 bit
ADIN_TAD = FRC              'RC OSC se�ili
ADIN_STIME = 50             '�rnekleme s�resi 50 mikrosaniye
Dim sure As Word            'sure de�i�keni 2 baytl�k word tipi olarak ayarland�. sebep; analog veri 10 bit
dim gelen as byte           'PIC e g�nderilen seri verinin tutulaca�� de�i�ken
dim manuel as portb.0       'el ile kontrolde portb nin 0 . biti se�ildi
dim ileri as portc.0        'el ile ileri y�n kontrolu tan�mland�
dim geri as portc.1         'el iler geri y�n kontrol� tan�mland�
dim durbutton as portc.2    'el ile dur kontrol� tan�mland�
trisb = %00000001           'PORTB nin t�m bitleri ��k�� DISPLAY i�in 
trisc = %10000011           'PORTC nin t�m bitleri giri� SER� veri al�m�
trisd = %00000000           'PORTD nin t�m bitleri ��k�� LED ve OPTOTRIAC lar� tetikler
TRISa = %00000001           'PORTA.0 analog veri giri�i olarak beilirlendi
ADCON1 = %10000000          'PORTA.0 daki ANALOG veri ayarland�
ANAPROGRAM:                 'Program�n ba�lad���na ili�kin bir etiket tan�mlad�k iste�e ba�l�d�r.Yal�nl�k a��s�ndan
    low portd               'PORTD nin t�m bitleri kapand�
    serout portc.6 , 16468, ["HO�GELD�N�Z",13,13,"BU S�M�LASYON NAZIM YILMAZ TARAFINDAN HAZIRLANMISTIR.",13,13,"KOMUTLAR :",13,13,"-- 1:�LER� -- 2:GER� -- 3:DUR --"]
    'Seri veri olarak "" i�erisindeki string ifadelerin yan� s�ra ASCII 13 de�eri g�nderildi.   
DONGU:                                              'dongu isimli bir etiket olu�turuldu            
while manuel=0                                      'manuel isimli anahtara ak�m gelmedi�i s�rece
    serin portc.7 , 16468,[ gelen ]                 'PORTC.7 den 9600 bps h�z�nda gelen veri okundu
    if gelen=49 then GOTO ILERIYON                  'gelen verinin ASCII si 49 mu bak�ld�
    if gelen=50 then GOTO GERIYON                   'gelen verinin ASCII si 50 ise ko�ulu    
    if gelen=51 then goto dur                       'gelen verinin ASCII si 51 ise   
wend                                                'while d�ng�s� sonu
if ileri=1 then goto ileriyon                       'ileri y�nde kullan�lacak butona ak�m verilirse
if geri=1 then goto geriyon                         'geri y�nde kullan�lacak butona ak�m verilirse
if durbutton=1 then dur                             'durbuttonu'na bas�l�rsa dur etiketine git
GOTO DONGU                                          'DONGU ye geri d�n
        ILERIYON:                                   'ileri y�n i�in kulln�lacak program etiketi
                sure = adin 0                       'Analog �evirim sonucu, sure de�i�kenine aktar�ld�
                print cls                           'Display in ekran� temizlendi
                print AT 1,1, "ILERI YONDE"         'Displayin 1.sat�r,1.s�tununa veri yaz�ld�
                print at 2,1, "YILDIZ DONUYOR"      'dispalin 2.sat�r 1.s�tununa veri yaz�ld�
                portd=0                             'PORTD nin t�m bitleri kapat�ld�
                LOW PORTC.4                         'PORTC.0 kapat�ld�
                LOW PORTC.5                         'PORTC.1 kapat�ld�
                portd=%11111000                     'PORTD nin 0,1,2,3,4 ve 5. bitleri a��l�p di�erleri kapat��d�
                delayms sure*3                      'okunan analog veri 3 ile �arp�larak y�ld�z bekleme s�resi ayarland�
                print AT 1,1, "ILERI YONDE"         '
                print at 2,1, "UCGEN DONUYOR"       '
                portd=0                             'PORTD nin t�m bitleri kapat�ld� low durumu
                delayms 30                          'y�ld�z-��gen olay�nda k�sa devreyi �nlemek i�in
                portd=%00111111                     'y�ld�zdan ��gene ge�ildi
            repeat                                  'repeat-until sonsuz d�ng�s�n�n ba��
            durbutton=0                             '
            if durbutton=1 and manuel=1 then        '   
            goto dur                                '
            endif                                   '
            if manuel=0 then goto dongu             '
            until 1=2                               '
        GOTO DONGU                                  'ASCII si 49 sa ifadesinin sonu if gelen=49 then            
        GERIYON:                                    '
                sure = adin 0                       'analog �evirim sonucu, sure de�i�kenine aktar�ld�
                print cls                           'displayin ekran�n� temizler
                print AT 1,1, "GERI YONDE"          '
                PRINT AT 2,1, "YILDIZ DONUYOR"      '
                portd=0                             '
                HIGH PORTC.4                        'PORTC nin 0. bitini a�ar yani 1 yapar sebep;ters y�nde hareket sa�lamak
                HIGH PORTC.5                        'PORTC nin 1. bitini a�ar yani 1 yapar sebep;ters y�nde hareket sa�lamak
                portd=%11010000                     'PORTD nin ter y�nde y�ld�z �el��mas�n� sa�alayan bitleri
                delayms sure*3                      'y�ld�zda kalma suresi
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
                sure = adin 0                               'durma i�leminin yap�laca�� komutlar�n ba�lama etiketi
                low portd                                   'PORTD nin t�m bitlerini kapat yani s�f�r (low) yap
                LOW PORTC.4                                 'PORTC.0 bitini kapat yani s�f�r (low) yap
                LOW PORTC.5                                 'PORTC.1 bitini kapat yani s�f�r (low) yap
                print cls,at 1,1, "ISLEM DURDURULDU"        'displayin ekran�n� temizler ve 1.sat�r 1.s�tuna "" i�indeki ifadeyi yazar
                print at 2,1, "SURE: ",dec sure*10," sl"    'analog veriyi 10 ile �arparak saliseyi bulduk   
        GOTO DONGU                                          'durum kontrol� i�im DONGU etiketine geri d�n�l�yor
end'ANAPROGRAM �n End i program burada sona erer.
