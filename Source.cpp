//; 抽鬼牌
//; 411262764張致寧
//; 411261564 黃柏勛
#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#include<string.h>

struct card {
    int point;
    char flower[4];
};
void bubble_sort(card user[], int size) {
    for (int i = size - 1; i > 0; i--) { // 外層迴圈：每次確定一個最大值位置
        for (int k = 0; k < i; k++) {    // 內層迴圈：將較大的值逐步移動到右側
            if (user[k].point > user[k + 1].point) { // 比較當前元素和下一個元素
                card temp = user[k];
                user[k] = user[k + 1];
                user[k + 1] = temp; // 交換
            }
        }
    }
}

void card_start(struct card all_card[]) {//牌初始化
    for (int i = 0; i < 13; i++) {
        all_card[i].point = i + 1;
        strcpy(all_card[i].flower, "梅");
    }
    for (int i = 0; i < 13; i++) {
        all_card[i + 13].point = i + 1;
        strcpy(all_card[i + 13].flower, "心");
    }
    for (int i = 0; i < 13; i++) {
        all_card[i + 26].point = i + 1;
        strcpy(all_card[i + 26].flower, "方");
    }
    for (int i = 0; i < 13; i++) {
        all_card[i + 39].point = i + 1;
        strcpy(all_card[i + 39].flower, "黑");
    }
    strcpy(all_card[52].flower, "鬼");
    all_card[52].point = 0;
}

void change(struct card all_card[]) {//洗牌
    srand(time(NULL));
    struct card temp;
    for (int i = 0; i < 53; i++) {
        int index_to_change = rand() % 53;
        temp = all_card[index_to_change];
        all_card[index_to_change] = all_card[i];
        all_card[i] = temp;
    }
}

void fapie(struct card p1[], struct card p2[], struct card p3[], struct card p4[], struct card all[]) {//發牌
    int p1_size = 0, p2_size = 0, p3_size = 0, p4_size = 0;

    for (int i = 0; i < 53; i++) {
        switch (i % 4) {
        case 0:
            p1[p1_size++] = all[i];
            break;
        case 1:
            p2[p2_size++] = all[i];
            break;
        case 2:
            p3[p3_size++] = all[i];
            break;
        case 3:
            p4[p4_size++] = all[i];
            break;
        }
    }
}

int diopie(struct card player[], int size) {
    int new_size = size;

    for (int i = 0; i < new_size - 1; i++) {
        int has_duplicates = 0; // 標記當前卡片是否有重複

        // 檢查與其他卡片是否有相同點數
        for (int k = i + 1; k < new_size; k++) {
            if (player[i].point == player[k].point) {
                has_duplicates = 1;

                // 移除第 k 張卡片
                for (int m = k; m < new_size - 1; m++) {
                    player[m] = player[m + 1];
                }
                new_size--; // 陣列大小減少
                k--; // 重新檢查新的位置 k
            }
        }

        // 如果有重複，移除第 i 張卡片
        if (has_duplicates) {
            for (int m = i; m < new_size - 1; m++) {
                player[m] = player[m + 1];
            }
            new_size--; // 陣列大小減少
            i--; // 重新檢查新的位置 i
        }
    }

    return new_size; // 回傳剩餘的卡片數量
}


void user_choose(struct card play1[], struct card play2[], int* player1_size, int* player2_size) {//玩家選牌
    int choose;
    if (*player2_size == 0) {
        printf("玩家二沒牌 跳過\n", *player2_size);
        return;
    }
    printf("玩家二還有%d張牌\n", *player2_size);
    scanf("%d", &choose);
    while (choose > *player2_size || choose < 0) {
        printf("選擇錯誤 重選:");
        scanf("%d", &choose);
    }
    choose--; 
    if (choose >= 0 && choose < *player2_size) {
        play1[*player1_size] = play2[choose]; 
        (*player1_size)++;
        for (int i = choose; i < *player2_size - 1; i++) {
            play2[i] = play2[i + 1];
        }
        (*player2_size)--;
    }
}

void cmp_choose(struct card cmp1[], struct card cmp2[], int* cmp1_size, int* cmp2_size) {//電腦選牌
    srand(time(NULL));
   
    if (*cmp2_size == 0) {
        return;
    }
    int choose = rand() % *cmp2_size;
    cmp1[*cmp1_size] = cmp2[choose];
    (*cmp1_size)++;
    for (int i = choose; i < *cmp2_size - 1; i++) {
        cmp2[i] = cmp2[i + 1];
    }
    (*cmp2_size)--;
}

int main() {
    struct card all_card[53];
    struct card player1_user[14], player2[13], player3[13], player4[13];
    card_start(all_card);
    change(all_card);
    fapie(player1_user, player2, player3, player4, all_card);
    int player1_size = 14, player2_size = 13, player3_size = 13, player4_size = 13;
    bubble_sort(player1_user, player1_size);
    player1_size = diopie(player1_user, player1_size);
    player2_size = diopie(player2, player2_size);
    player3_size = diopie(player3, player3_size);
    player4_size = diopie(player4, player4_size);
    bubble_sort(player1_user, player1_size);
    bubble_sort(player2, player2_size);
    bubble_sort(player3, player3_size);
    bubble_sort(player4, player4_size);
    while (1) {   /*遊戲迴圈*/
        printf("玩家手牌\n");
        for (int i = 0; i < player1_size; i++) {
            printf("%d  %s  ", player1_user[i].point, player1_user[i].flower);
        }
        printf("\n");
        if ((player4_size == 1 && player4[0].point == 0)) {   /* 判斷書家*/
            printf("玩家四輸\n");
            break;
        }
        else if ((player1_size == 1 && player1_user[0].point == 0)) {
            printf("玩家一輸\n");
            break;
        }
        else if ((player3_size == 1 && player3[0].point == 0)) {
            printf("玩家三輸\n");
            break;
        }
        else if ((player2_size == 1 && player2[0].point == 0)) {
            printf("玩家二輸\n");
            break;
        }
        user_choose(player1_user, player2, &player1_size, &player2_size);   /*抽排丟牌*/
        player1_size = diopie(player1_user, player1_size);
        cmp_choose(player2, player3, &player2_size, &player3_size);
        player2_size = diopie(player2, player2_size);
        cmp_choose(player3, player4, &player3_size, &player4_size);
        player3_size = diopie(player3, player3_size);
        cmp_choose(player4, player1_user, &player4_size, &player1_size);
        player4_size = diopie(player4, player4_size);
        if ((player4_size == 1 && player4[0].point == 0)) {   /* 判斷書家*/
            printf("玩家四輸\n");
            break;
        }
        else if ((player1_size == 1 && player1_user[0].point == 0)) {
            printf("玩家一輸\n");
            break;
        }
        else if ((player3_size == 1 && player3[0].point == 0)) {
            printf("玩家三輸\n");
            break;
        }
        else if ((player2_size == 1 && player2[0].point == 0)) {
            printf("玩家二輸\n");
            break;
        }
        bubble_sort(player1_user, player1_size);   /* 排大小*/
        bubble_sort(player2, player2_size);
        bubble_sort(player3, player3_size);
        bubble_sort(player4, player4_size);
    }
    return 0;
}
