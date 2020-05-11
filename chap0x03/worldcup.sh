#!/usr/bin/env bash

age_count()
{
a=$(more +2  worldcupplayerinfo.tsv|awk -F\\t '{print $6}'|sort -r|awk 'BEGIN{split("<20 20-30 >30",b)}{if($1<20)a[1]++;if($1>=20&&$1<=30)a[2]++;if($1>30)a[3]++}END{for(i in a)print a[i]}')

#总人数
sum=0
age=($a)
for i in $a ;do
  sum=$((sum+i)) 
done

#百分比
a=("20岁以下的球员" "20-30岁的球员" "30岁以上的球员")
for i in $(seq 0 2);do
	b[$i]="$(printf "%.2f" "$(echo "scale=6; 100*${age[$i]} / $sum"|bc)")"
done

echo -e "------不同年龄区间的球员数量和百分比------\n"
for i in $(seq 0 2);do
echo -e "${a[$i]}  人数: ${age[$i]} 占比: ${b[$i]}% \n "
done
}


#uniq -c函数使用之前 使用 sort 命令使所有重复行相邻
pos_count()
{
	a=$(more +2 worldcupplayerinfo.tsv|awk -F\\t '{print $5}'|sort -r|uniq -c|awk '{print $1}')
	b=$(more +2 worldcupplayerinfo.tsv|awk -F\\t '{print $5}'|sort -r|uniq -c|awk '{print $2}')
	sum=0
	count=($a)
	position=($b)

    #求和
	for i in $a ;do
		sum=$((sum+i)) 
	done

#遍历计算百分比
i=0
for n in "${count[@]}";do
	b[$i]="$(printf "%.2f" "$(echo "scale=6; 100*${n} / $sum"|bc)")"
  i=$((i+1))
done

#进行输出打印
echo -e "----不同场上位置的球员数量和百分比------\n"
i=0
for n in "${count[@]}";do
echo -e "位置: ${position[$i]}  人数: $n   占比: ${b[$i]}% \n" 
i=$((i+1))
done
}


young()
{
#首先找出年龄最小的数值
young=$(more +2 worldcupplayerinfo.tsv | awk -F\\t 'BEGIN{young=100}{if($6<=young){young=$6}}END{print young}')

#然后把所有年龄为该数值的名字取出
temp="more +2 worldcupplayerinfo.tsv | awk -F'\t' 'BEGIN{young=${young};i=1}{if("'$6'"==young){name[i]="'$9'";i++}}END{for (a in name)print name[a]}'"

name="$(eval -- "$temp")"

echo -e "------年龄最小的球员------\n"
echo -e "最小年龄是: ${young} "
echo -e "名字是 : "
IFS=$'\n' namearray=($name)
for key in "${!namearray[@]}"; do echo -e "${namearray[$key]} \n"; done


}

old()
{
#计算方式和计算最小的年龄类似
old=$(more +2 worldcupplayerinfo.tsv | awk -F\\t 'BEGIN{old=0}{if($6>=old){old=$6}}END{print old}')

temp="more +2 worldcupplayerinfo.tsv | awk -F'\t' 'BEGIN{old=${old};i=1}{if("'$6'"==old){name[i]="'$9'";i++}}END{for (a in name)print name[a]}'"


name="$(eval -- "$temp")"

echo -e "------年龄最大的球员------\n"
echo -e "最大年龄: ${old} "
echo -e "名字是 : "
IFS=$'\n' namearray=($name)
for key in "${!namearray[@]}"; do echo -e "${namearray[$key]} \n"; done


}

longgest_name()
{

name=$(more +2 worldcupplayerinfo.tsv | awk -F\\t '{print $9}') 
long=0
IFS=$'\n' namearray=($name)

#首先求出名字最长的数值是多少
for i in ${namearray[*]} ; do
	count=( "$(echo -n "$i" | wc -m )" )
  if [ "$count" -gt "$long" ] ; then
    long=$count
  fi
done

#然后遍历寻找长度符合条件的名字
num=0
longarray=()
for i in ${namearray[*]} ; do
	count=( "$(echo -n "$i" | wc -m)" )
  if [ "$count" -eq "$long" ] ; then
    longarray[${num}]=$i
    num=$((num+1))
  fi
done

echo -e "------名字最长的球员-------\n"
echo -e "名字长度: ${long} "
echo -e "名字是: "
for key in "${!longarray[@]}"; do echo -e "${longarray[$key]} \n"; done

}

#同上
shortest_name()
{

name=$(more +2 worldcupplayerinfo.tsv | awk -F\\t '{print $9}') 
short=100
IFS=$'\n' namearray=($name)

for i in ${namearray[*]} ; do
	count=( "$(echo -n "$i" | wc -m )" )
  if [ "$count" -lt "$short" ] ; then
    short=$count
  fi
done

num=0
shortarray=()
for i in ${namearray[*]} ; do
	count=( "$(echo -n "$i" | wc -m)" )
  if [ "$count" -eq "$short" ] ; then
    shortarray[${num}]=$i
    num=$((num+1))
  fi
done

echo -e "------名字最短的球员------\n"

echo -e "名字长度: ${short} "
echo -e "名字是 : "
for key in "${!shortarray[@]}"; do echo -e "${shortarray[$key]} \n"; done

}

age_count
pos_count
longgest_name
shortest_name
old
young
