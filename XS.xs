#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>
#include "ppport.h"
#include <math.h>

struct sv_with_distance {
    double distance;
    SV **svp;
};

void static add_to_the_list(
        struct sv_with_distance *list,
        int *length,
        int max,
        const struct sv_with_distance *item)
{
    int i;
    if (*length == 0
        || *length < max && list[*length - 1].distance <= item->distance)
    {
        /* add this item to the end of the list */
        list[*length].distance = item->distance;
        list[*length].svp = item->svp;
        (*length)++;
    } else if(list[*length - 1].distance > item->distance) {
        /* insert new element into list */
        for (i=0; list[i].distance <= item->distance; i++);
        memmove(list+i+1, list+i, (*length-i) * sizeof(struct sv_with_distance));
        list[i].distance = item->distance;
        list[i].svp = item->svp;
        if(*length < max) (*length)++;
    }
}

MODULE = Number::Closest::XS    PACKAGE = Number::Closest::XS    PREFIX = nclosx_
PROTOTYPES: DISABLE

AV*
nclosx_find_closest_numbers(center, source, ...)
        double center;
        AV* source;
    PREINIT:
        int length = 0;
        int amount = 1;
        int source_length;
        int i, j;
        double distance;
        struct sv_with_distance *sorted, item;
    CODE:
        if (items > 2) amount = SvIV(ST(2));
        RETVAL=newAV();
        sv_2mortal((SV*)RETVAL);
        source_length = av_len(source);
        if (source_length >= 0 && amount > 0) {
            /* amount + 1 is to simplify memmove */
            Newx(sorted, amount + 1, struct sv_with_distance);
            for (i=0; i<= source_length; i++) {
                item.svp = av_fetch(source, i, 0);
                if (item.svp != NULL) {
                    item.distance = fabs(center - SvNV(*item.svp));
                    add_to_the_list(sorted, &length, amount, &item);
                }
            }
            for (i=0; i<length; i++) {
                av_push(RETVAL, newSVsv(*sorted[i].svp));
            }
            Safefree(sorted);
        }
    OUTPUT:
        RETVAL

AV*
nclosx_find_closest_numbers_around(center, source, ...)
        double center;
        AV* source;
    PREINIT:
        int source_length;
        int amount = 2;
        int i, j;
        double distance;
        double abs_dist;
        struct sv_with_distance *left, *right, item;
        int left_len=0, right_len=0, left_pos=0, right_pos=0;
    CODE:
        if (items > 2) amount = SvIV(ST(2));
        RETVAL=newAV();
        sv_2mortal((SV*)RETVAL);
        source_length = av_len(source);
        if (source_length >= 0 && amount > 1) {
            /* amount + 1 is to simplify memmove */
            Newx(left, amount + 1, struct sv_with_distance);
            Newx(right, amount + 1, struct sv_with_distance);
            for (i=0; i<= source_length; i++) {
                item.svp = av_fetch(source, i, 0);
                if (item.svp != NULL) {
                    item.distance = SvNV(*item.svp) - center;
                    if (item.distance <= 0) {
                        item.distance = fabs(item.distance);
                        add_to_the_list(left, &left_len, amount, &item);
                    } else {
                        add_to_the_list(right, &right_len, amount, &item);
                    }
                }
            }
            /* first get a closest number from each side if possible */
            if (left_len > 0) {
                av_push(RETVAL, newSVsv(*left[0].svp));
                left_pos++;
                amount--;
            }
            if (right_len > 0) {
                av_push(RETVAL, newSVsv(*right[0].svp));
                right_pos++;
                amount--;
            }
            while (amount > 0 && (right_pos < right_len || left_pos < left_len)) {
                if (right_pos >= right_len) {
                    /* if there's nothing left on the right get from the left list */
                    int n = amount < left_len - left_pos ? amount : left_len - left_pos;
                    av_unshift(RETVAL, n );
                    while (n-- > 0)
                        av_store(RETVAL, n, newSVsv(*left[left_pos++].svp));
                    break;
                } else if (left_pos >= left_len) {
                    /* if there's nothing left on the left get from the right list */
                    int n = amount < right_len - right_pos ? amount : right_len - right_pos;
                    while (n-- > 0)
                        av_push(RETVAL, newSVsv(*right[right_pos++].svp));
                    break;
                } else {
                    /* get closest number */
                    if (left[left_pos].distance < right[right_pos].distance) {
                        av_unshift(RETVAL, 1);
                        av_store(RETVAL, 0, newSVsv(*left[left_pos].svp));
                        left_pos++;
                        amount--;
                    } else {
                        av_push(RETVAL, newSVsv(*right[right_pos].svp));
                        right_pos++;
                        amount--;
                    }
                }
            }
            Safefree(left);
            Safefree(right);
        }
    OUTPUT:
        RETVAL
