# Auromita 
# July 19, 2021
# Remove duplicate items from a file, and write into another file

# read in the file with duplicates
f = open ('../phones_temp.txt', encoding="utf8")
text = f.read()
f.close()
words = text.split('\n')

# make file to write results
final = open('../phones.txt','w', encoding="utf8")

# list for storing unique items
words_unique = []

for w in words:
	if w not in words_unique:
		words_unique.append(w)
		final.writelines('%s\n' % w)


final.close()

# for w in words:
# 	if w not in words_unique:
# 		words_unique.append(w)
# 		print(w)



print("done!")
print("total items: ", len(words))
print("unique items:", len(words_unique))
